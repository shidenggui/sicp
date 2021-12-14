import sys

import operator
from dataclasses import dataclass
from typing import Callable

sys.setrecursionlimit(10000)


class Env(dict):
    def __init__(self, variables=None, parent=None):
        super().__init__()
        if variables:
            self.update(variables)
        self.parent = parent

    def find(self, name: str) -> "Env":
        if name in self:
            return self
        if self.parent:
            return self.parent.find(name)
        raise NameError(f"{name} is not defined")


PRIMITIVES = {
    "+": operator.add,
    "-": operator.sub,
    "*": operator.mul,
    "/": operator.truediv,
    "=": operator.eq,
    "<=": operator.le,
    ">=": operator.ge,
    "remainder": operator.mod,
    "true": True,
    "false": False,
    "cons": lambda x, y: [x, y],
    "car": lambda x: x[0],
    "cdr": lambda x: x[1:],
    "null?": lambda x: x == [],
    "number?": lambda x: isinstance(x, Number),
    "symbol?": lambda x: isinstance(x, str),
    "pair?": lambda x: isinstance(x, list),
    "eq?": operator.eq,
    "display": lambda x: print(x, end=""),
    "newline": lambda: print(),
}


def is_primitive(proc) -> bool:
    return proc in PRIMITIVES.values()


def setup_standard_env() -> Env:
    env = Env()
    env.update(PRIMITIVES)
    return env


global_env = setup_standard_env()

## Types
List = list
Symbol = str
Number = (int, float)

## Parsing
def tokenize(text: str) -> list[str]:
    # support two procedures inside oneline, like "(define a 3) (define b 4)"
    def make_begin():
        return f"(begin {text})"

    text = make_begin()
    return text.replace("(", " ( ").replace(")", " ) ").split()


def parse_tokens(tokens: list[str]):
    if not tokens:
        raise SyntaxError("unexpected EOF")

    token = tokens.pop(0)
    if token == "(":
        node = []
        while tokens[0] != ")":  # parse sub expressions
            node.append(parse_tokens(tokens))
        tokens.pop(0)  # pop ')'
        return node
    elif token == ")":
        raise SyntaxError("unexpected )")
    if token.isdigit():
        return int(token)
    try:
        return float(token)
    except:
        return Symbol(token)


@dataclass
class Procedure:
    params: list[str]
    body: list
    env: Env

    def __call__(self, *args):
        return eval(self.body, Env(zip(self.params, args), self.env))


## Evaluator
def apply(f, *args, **kwargs):
    return f(*args, **kwargs)


def force(arg):
    while isinstance(arg, Callable):
        arg = arg()
    return arg


def eval(exp, env: Env):
    # primitives
    if isinstance(exp, Number):
        return exp
    if isinstance(exp, Symbol):
        return env.find(exp)[exp]
    if isinstance(exp, Callable):
        return exp()
    # lambda
    if exp[0] == "lambda":
        _, params, *body = exp
        return Procedure(params, ["begin", *body], env=env)
    # begin
    if exp[0] == "begin":
        return [eval(x, env) for x in exp[1:]][-1]
    if exp[0] == "quote":
        return exp[1:]
    if exp[0] == "let":
        _, bindings, *body = exp
        return eval(["begin", *body], Env(dict(bindings), env))
    if exp[0] == "if":
        _, predicate, consequent, alternative = exp
        return eval(consequent, env) if eval(predicate, env) else eval(alternative, env)
    if exp[0] == "set!":
        _, name, value = exp
        env.find(name)[name] = eval(value, env)
        return None
    if exp[0] == "define":
        _, name, *value = exp
        # define method
        # (define (mul a b) (* a b))
        if isinstance(name, List):
            env[name[0]] = Procedure(name[1:], ["begin", *value], env=env)
        # define variable
        # (define pi 3.14)
        else:
            env[name] = eval(value[0], env)
        return None
    # else exp is proc
    proc = eval(exp[0], env)
    if is_primitive(proc):
        args = [force(eval(arg, env)) for arg in exp[1:]]
        return apply(proc, *args)

    def memorized_thunk(arg):
        _cache = None

        def wrapper():
            nonlocal _cache
            if _cache is None:
                _cache = eval(arg, env)
            return _cache

        return wrapper

    lazy_args = [memorized_thunk(arg) for arg in exp[1:]]
    # lazy_args = [lambda arg=arg: eval(arg, env) for arg in exp[1:]]
    return apply(proc, *lazy_args)


## Repl
def repl():
    def is_valid_syntax(text: str) -> bool:
        try:
            parse_tokens(tokenize(text))
            return True
        except:
            return False

    text = ""
    while inputs := input("lisp.py> " if not text else "         "):
        text += inputs
        if not is_valid_syntax(text):
            continue
        try:
            if output := force(eval(parse_tokens(tokenize(text)), global_env)):
                print(output)
        except Exception as e:
            print(f"; {e}")
        text = ""


repl()
# (define count 0)
# (define (id x) (set! count (+ count 1)) x)
# (define w (id (id 10)))
# count
# ; => 1 // Because before evaluating w, the w => (id (id 10)) => (set! count (+ count 1) (delayed (id 10)))
# ; the (delayed (id 10)) is evaluated when evaluating w, so we only call id once
# w
# ; => 10
# count
# ; => 2

