# vim: set fileencoding=utf-8
"""
pythoneda/realm/rydnr/infrastructure/dbus/rydnr_dbus_signal_emitter.py

This file defines the RydnrDbusSignalEmitter class.

Copyright (C) 2023-today rydnr's pythoneda-realm-rydnr/infrastructure

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
"""
from dbus_next import BusType
from pythoneda.shared.artifact.events import ChangeStaged
from pythoneda.shared.artifact.events.infrastructure.dbus import DbusChangeStaged
from pythoneda.shared.infrastructure.dbus import DbusSignalEmitter
from typing import Dict


class UnveilingpartnerDbusSignalEmitter(DbusSignalEmitter):

    """
    A Port that emits UnveilingPartner events as d-bus signals.

    Class name: UnveilingPartnerDbusSignalEmitter

    Responsibilities:
        - Connect to d-bus.
        - Emit domain events as d-bus signals on behalf of Rydnr.

    Collaborators:
        - pythoneda.shared.application.PythonEDA: Requests emitting events.
        - pythoneda.shared.artifact.events.infrastructure.dbus.DbusChangeStaged
    """

    def __init__(self):
        """
        Creates a new UnveilingpartnerDbusSignalEmitter instance.
        """
        super().__init__()

    def signal_emitters(self) -> Dict:
        """
        Retrieves the configured event emitters.
        :return: For each event, a list with the event interface and the bus type.
        :rtype: Dict
        """
        result = {}
        key = self.__class__.full_class_name(ChangeStaged)
        result[key] = [DbusChangeStaged, BusType.SYSTEM]

        return result
# vim: syntax=python ts=4 sw=4 sts=4 tw=79 sr et
# Local Variables:
# mode: python
# python-indent-offset: 4
# tab-width: 4
# indent-tabs-mode: nil
# fill-column: 79
# End:
