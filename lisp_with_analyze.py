import sys

import operator
from dataclasses import dataclass

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


def setup_standard_env() -> Env:
    env = Env()
    env.update(
        {
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
    )
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


def analyze(exp):
    # primitives
    if isinstance(exp, Number):
        return lambda env: exp
    if isinstance(exp, Symbol):
        return lambda env: env.find(exp)[exp]
    # lambda
    if exp[0] == "lambda":
        _, params, *body = exp
        return lambda env: Procedure(params, ["begin", *body], env=env)
    # begin
    if exp[0] == "begin":
        return lambda env: [eval(x, env) for x in exp[1:]][-1]
    if exp[0] == "quote":
        return lambda env: exp[1:]
    if exp[0] == "let":
        _, bindings, *body = exp
        return lambda env: eval(["begin", *body], Env(dict(bindings), env))
    if exp[0] == "if":
        _, predicate, consequent, alternative = exp
        return lambda env: eval(consequent, env) if eval(predicate, env) else eval(alternative, env)
    if exp[0] == "set!":
        _, name, value = exp

        def set(env):
            env.find(name)[name] = eval(value, env)

        return set
    if exp[0] == "define":
        _, name, *value = exp
        # define method
        # (define (mul a b) (* a b))
        if isinstance(name, List):

            def define(env):
                env[name[0]] = Procedure(name[1:], ["begin", *value], env=env)

        # define variable
        # (define pi 3.14)
        else:

            def define(env):
                env[name] = eval(value[0], env)

        return define
    # else exp is proc
    def call_proc(env):
        proc = eval(exp[0], env)
        args = [eval(arg, env) for arg in exp[1:]]
        return apply(proc, *args)

    return call_proc


def eval(exp, env: Env):
    return analyze(exp)(env)


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
            if output := eval(parse_tokens(tokenize(text)), global_env):
                print(output)
        except Exception as e:
            print(f"; {e}")
        text = ""


# ???????????????????????????
text = """(define (fib n) (if (<= n 2) 1 (+ (fib (- n 1)) (fib (- n 2))))) 
(fib 20)"""
parsed = parse_tokens(tokenize(text))

# lisp.py
# In [4]: timeit eval(parsed, global_env)
# 156 ms ?? 8.09 ms per loop (mean ?? std. dev. of 7 runs, 10 loops each)

# lisp_with_analyze.py
# In [4]: timeit eval(parsed, global_env)
# 229 ms ?? 3.55 ms per loop (mean ?? std. dev. of 7 runs, 1 loop each)

# ????????????????????????????????????????????? Python ???????????????????????? lambda ??????????????????
# ?????????????????????????????????????????????????????????????????? C ?????????
