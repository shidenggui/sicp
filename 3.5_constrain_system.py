from dataclasses import dataclass, field
from typing import Any, List


class Constraint:
    def process_new_value(self):
        raise NotImplementedError

    def process_forget_value(self):
        raise NotImplementedError


@dataclass
class Connector:
    value: Any = None
    informant: Any = None
    constraints: List[Constraint] = field(default_factory=list)

    def has_value(self):
        return bool(self.informant)

    def set_value(self, value, informant):
        if self.has_value() and self.value != value:
            raise Exception(f"Contradiction: ({self.value}, {value})")
        self.value, self.informant = value, informant
        for constraint in self.constraints:
            if constraint != informant:
                constraint.process_new_value()

    def forget_value(self, informant):
        if self.informant == informant:
            self.informant = None
            for constraint in self.constraints:
                if constraint != informant:
                    constraint.process_forget_value()

    def connect(self, new_constraint):
        if new_constraint not in self.constraints:
            self.constraints.append(new_constraint)
        if self.has_value():
            new_constraint.process_new_value()


@dataclass
class Adder(Constraint):
    a1: Connector
    a2: Connector
    sum: Connector

    def __post_init__(self):
        self.a1.connect(self)
        self.a2.connect(self)
        self.sum.connect(self)

    def process_new_value(self):
        if self.a1.has_value() and self.a2.has_value():
            self.sum.set_value(self.a1.value + self.a2.value, self)
        elif self.a1.has_value() and self.sum.has_value():
            self.a2.set_value(self.sum.value - self.a1.value, self)
        elif self.a2.has_value() and self.sum.has_value():
            self.a1.set_value(self.sum.value - self.a2.value, self)

    def process_forget_value(self):
        self.a1.forget_value(self)
        self.a2.forget_value(self)
        self.sum.forget_value(self)
        self.process_new_value()


@dataclass
class Constant(Constraint):
    value: Any
    connector: Connector

    def __post_init__(self):
        self.connector.connect(self)
        self.connector.set_value(self.value, self)

    def process_new_value(self):
        pass

    def process_forget_value(self):
        pass


@dataclass
class Multiplier(Constraint):
    m1: Connector
    m2: Connector
    product: Connector

    def __post_init__(self):
        self.m1.connect(self)
        self.m2.connect(self)
        self.product.connect(self)

    def process_new_value(self):
        if self.m1.has_value() and self.m1.value == 0:
            self.product.set_value(0, self)
        elif self.m2.has_value() and self.m2.value == 0:
            self.product.set_value(0, self)
        elif self.m1.has_value() and self.m2.has_value():
            self.product.set_value(self.m1.value * self.m2.value, self)
        elif self.m1.has_value() and self.product.has_value():
            self.m2.set_value(self.product.value / self.m1.value, self)
        elif self.m2.has_value() and self.product.has_value():
            self.m1.set_value(self.product.value / self.m2.value, self)

    def process_forget_value(self):
        self.m1.forget_value(self)
        self.m2.forget_value(self)
        self.product.forget_value(self)
        self.process_new_value()


@dataclass
class Probe(Constraint):
    name: str
    connector: Connector

    def __post_init__(self):
        self.connector.connect(self)

    def process_new_value(self):
        print(f"Probe: {self.name} = {self.connector.value}")

    def process_forget_value(self):
        print(f"Probe: {self.name} = ?")


def celsius_fahrenheit_converter(c, f):
    u = Connector()
    v = Connector()
    w = Connector()
    x = Connector()
    y = Connector()
    Multiplier(c, w, u)
    Multiplier(v, x, u)
    Adder(v, y, f)
    Constant(9, w)
    Constant(5, x)
    Constant(32, y)


C = Connector()
F = Connector()
Probe("Fahrenheit temp", F)
Probe("Celsius temp", C)
celsius_fahrenheit_converter(C, F)
C.set_value(25, "user")
C.forget_value("user")
F.set_value(212, "user")
