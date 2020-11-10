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