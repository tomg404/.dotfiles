#!/usr/bin/python3

from dataclasses import dataclass, field
from dataclass_wizard import YAMLWizard
import subprocess
import yaml
import distro
from pathlib import Path
from abc import ABC, abstractmethod

from console.progress import ProgressBar

class System:
    """
    The System class stores high-level ideas of commonly used commands.
    Should be divided into subclasses in future versions for other operating systems.
    """
    def program_exists(self, program_name: str):
        """Returns true if the programs binary exists (is callable)"""
        r = subprocess.run(["which", program_name], check=False, stdout=subprocess.DEVNULL).returncode
        return not bool(r)    


class PackageManager(ABC):
    """
    Package Manager is an abstract class and works as an interface to work with 
    different package managers on different linux distributions.
    """
    @property
    def name(self) -> str:
        raise NotImplementedError()

    @property
    def binary_name(self) -> str:
        raise NotImplementedError()

    @abstractmethod
    def install(self, program_list: list[str]) -> None:
        pass


class Apt(PackageManager):
    name = "apt"
    binary_name = "apt-get"

    def install(self):
        pass


class Stow:
    """
    Interface class for the GNU stow project
    """
    pass


@dataclass
class Program():
    name: str 
    executable: str
    package: str | list[dict[str, str]] = None


@dataclass
class Config(YAMLWizard):
    programs: list[Program]


class Printer:
    """
    The printer class handles (like expected) all printing to the terminal.
    """
    found = '🟢'
    not_found = '🔴'

    def check_installed_begin(self) -> None:
        pass

    def found_program(self, prog: Program, installed: bool) -> None:
        character = self.found if installed else self.not_found
        print(f"{character} {prog.name} ({prog.executable})")

    def check_installed_end(self, n: int, total: int) -> None:
        bar = ProgressBar(total=total)
        print("\nInstalled:")
        print(bar(n))


class Main:
    def __init__(self, programs_config_path):
        self.programs_config_path : Path = programs_config_path
        self.config = Config.from_yaml_file(self.programs_config_path)
        self.programs = self.config.programs

        self.package_manager : PackageManager = None
        self.system = System()
        self.printer = Printer()

        # load correct package manager
        id = distro.like().split(",")[0]
        if id == "debian":
            self.package_manager = Apt()
        elif id == "arch":
            raise NotImplementedError("The package management for arch is currently not supported!")
        else:
            raise OSError("Your operating system is not supported!")

    def check_installed(self):
        self.printer.check_installed_begin()

        num_of_installed_programs = 0
        num_of_programs = len(self.programs)
        for program in self.programs:
            installed = self.system.program_exists(program.executable)
            if installed:
                num_of_installed_programs += 1
            self.printer.found_program(program, installed)

        self.printer.check_installed_end(num_of_installed_programs, num_of_programs)

    def check_stowed(self):
        pass


if __name__ == "__main__":
    programs = Path(__file__).parent / "programs.yaml"
    m = Main(programs)

    m.check_installed()
    m.check_stowed()
