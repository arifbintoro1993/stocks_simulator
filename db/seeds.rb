# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Product.find_or_create_by(
    name: "Product-Test",
    sku: "sku-product-test-001"
)

Product.find_or_create_by(
    name: "Product-Test-2",
    sku: "sku-product-test-002"
)

Location.find_or_create_by(
    name: "Location-Test",
    code: 'location-test-code-001'
)

Location.find_or_create_by(
    name: "Location-Test-2",
    code: 'location-test-code-002'
)