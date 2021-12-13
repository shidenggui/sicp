def integers(start=1):
    while True:
        yield start
        start += 1
  
def sieve(stream):
    v = next(stream)
    yield v
    yield from sieve(filter(lambda x: x % v != 0, stream))
  
primes = sieve(integers(start=2))
print(next(primes))
print(next(primes))