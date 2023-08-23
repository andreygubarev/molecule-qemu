import os

from molecule import logger, util
from molecule.api import Driver

LOG = logger.get_logger(__name__)


class QEMU(Driver):
    def __init__(self, config=None) -> None:
        super().__init__(config)
        self._name = "molecule-qemu"

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, value):
        self._name = value

    def sanity_checks(self):
        pass

    def template_dir(self):
        return os.path.join(os.path.dirname(__file__), "cookiecutter")

    @property
    def default_safe_files(self):
        return [self.instance_config]

    @property
    def default_ssh_connection_options(self):
        return self._get_ssh_connection_options()

    @property
    def login_cmd_template(self):
        connection_options = " ".join(self.ssh_connection_options)

        return (
            "ssh {{address}} "
            "-l {{user}} "
            "-p {{port}} "
            "-i {{identity_file}} "
            "{}"
        ).format(connection_options)

    def login_options(self, instance_name):
        d = {"instance": instance_name}

        return util.merge_dicts(d, self._get_instance_config(instance_name))

    def ansible_connection_options(self, instance_name):
        try:
            d = self._get_instance_config(instance_name)

            return {
                "ansible_user": d["user"],
                "ansible_host": d["address"],
                "ansible_port": d["port"],
                "ansible_private_key_file": d["identity_file"],
                "connection": "ssh",
                "ansible_ssh_common_args": " ".join(self.ssh_connection_options),
            }
        except StopIteration:
            return {}
        except IOError:
            return {}

    def _get_instance_config(self, instance_name):
        instance_config_dict = util.safe_load_file(self._config.driver.instance_config)
        return next(
            item for item in instance_config_dict if item["name"] == instance_name
        )

    def schema_file(self):
        return os.path.join(os.path.dirname(__file__), "driver.json")
