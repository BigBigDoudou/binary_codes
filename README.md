# README

> Experimentation around binary use for persisting combinations.

## Example application

In this application, there is a given list of `rights` (`Array<string>`).

In the database, `user` and `role` are related: a `user` can have many `roles` and a `role` is supported by many `users`.

Every records of `user` and `role` handle many rights.

A user inherits rights from its roles.

**Scenario**

A specific `user` John Doe is allow to `"search"` and `"connect api"`. He has a role `admin` and this role allows all users that have it to `"manage users"` and `"validate projects"`.

Eventually, the user has those 4 rights, 2 directly and 2 inherited.

## Encoding and decoding system

To persist these rights combination in the database, we use a binary (an integer column) which represents the combination.

A list of rights can be encoded into a binary, and a binary can be decoded back into a list of rights.

This encoding/decoding is based on a "key list", which enumerate the rights and is not meant to evolve (index of each right is used in the process).

**Example**

```ruby
key_list = [
  'alfa',    # 0
  'bravo',   # 1
  'charlie', # 2
  'delta',   # 3
  'echo'     # 4
]

encoded = 9     # base 10
binary  = 01101 # base 2
#         x32x0 # starting from right with 0, add index if binary is 1

indexes = [0, 2, 3]

decoded = ['alfa', 'charlie', 'delta']
```

## Abstraction

This system is abstracted with the `RightsConcern`.

It is possible to get the list of rigths with `User#rights` and `Role#rights`: this will decode the binary from database (`rights_code` attribute ) and return an array of strings.

It is possible to set the list of rigths with `User#rights=` and `Role#rights=`: this will encode the array of strings into a binary and save it in database (`rights_code` attribute ).

```ruby
user.rights_code       # => 9 (persisted in database)
user.rights            # => ['alfa', 'charlie', 'delta'] (decoded in ruby)

user.rights = ['alfa'] # set rights_code attribute
user.rights_code       # => 1
```

For the `User` only:
* `#full_rights` returns the union of self rights and roles rights;
* `#can?(right)` returns `true` if the user has this right (directly or inherited).

```ruby
user.rights = ['alfa', 'charlie']
role = user.roles.create
role.rights = ['alfa', 'bravo', 'echo']
user.full_rights # => ['alfa', 'bravo', 'charlie', 'echo']
user.can?('bravo') # => true
user.can?('delta') # => false
```

## Benchmark

The `decode` system is heavier with binary, especially with a large `key_list`.

```
encoding ---
  0.080456   0.000585   0.081041 (  0.081114)
  0.075620   0.000081   0.075701 (  0.075731)
  -> Encoding with binary takes 0.07 more time than the 'array to string' system

decoding ---
  0.103538   0.000048   0.103586 (  0.103649)
  0.046664   0.000000   0.046664 (  0.046668)
  -> Decoding with binary takes 1.22 more time than the 'string to array' system

union ---
  0.097521   0.000079   0.097600 (  0.097660)
  0.149942   0.000000   0.149942 (  0.149981)
  -> Union with binary takes -0.35 more time than with arrays

include ---
  0.039531   0.000000   0.039531 (  0.039589)
  0.060483   0.000000   0.060483 (  0.060497)
  -> Checking inclusion with binary takes -0.35 more time than with arrays
  ```