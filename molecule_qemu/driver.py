import os

from molecule import logger, util
from molecule.api import Driver

LOG = logger.get_logger(__name__)


class QEMU(Driver):
    def __init__(self, config=None) -> None:
        super().__init__(config)
        self._name = "molecule_qemu"

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
