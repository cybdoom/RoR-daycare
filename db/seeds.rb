if Role.count < 1
  @role1 = Role.create(name: 'superadmin')
end

if User.count < 1
  User.create_with(password: "password",password_confirmation: "password", role_id: @role1.id).find_or_create_by(email: "tareqgholam@daycare.org")
end