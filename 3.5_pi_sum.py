from itertools import islice
def pi_sum(n=1, sign=1, pi=0):
    yield pi
    yield from pi_sum(n + 2, -sign, pi + 1/n * sign)

def pi():
    yield from map(lambda x: x *4, pi_sum())

print(list(islice(pi(), 5)))

def euler_transform(stream):
  s0 = next(stream)
  s1 = next(stream)
  s2 = next(stream)
  yield s2 - (s2 - s1) ** 2 / (s0 - 2 * s1 + s2)
  yield from euler_transform(stream)

print(list(islice(euler_transform(pi()), 5)))
print(list(islice(euler_transform(euler_transform(pi())), 5)))

def make_tableau(transform, s):
  yield next(s)
  yield from make_tableau(transform, transform(s))

print(
  list(islice(
    make_tableau(euler_transform, pi()), 5)))