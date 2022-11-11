alias UnterEats.Repo
alias UnterEats.Users.User

password = Bcrypt.hash_pwd_salt("foobar")

user = %User{
  email: "user@example.com",
  password_hash: password
}

Repo.insert(user, on_conflict: :nothing)
