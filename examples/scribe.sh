#!/bin/sh

set -eu

Maybe_Create_App() {
  local _app_dir="${TARGET_DIR}/${APP_DIRNAME}"

  if [ -d "${_app_dir}" ]; then
    cd "${_app_dir}"
    git stash -u
  else
    mkdir -p "${TARGET_DIR}"
    cd "${TARGET_DIR}"
    mix phx.new "${APP_DIRNAME}" --database sqlite3

    echo "Setup the new app with Elixir Scribe. Add database files to a folder ignored by git."

    exit 0
  fi
}

Online_Shop() {

  Maybe_Create_App

  # CONTENT
  mix scribe.gen.html OnlineShop.Content Home home --no-schema --no-default-actions --actions render
  mix scribe.gen.html OnlineShop.Content ProductList product_lists --no-schema --no-default-actions --actions list
  mix scribe.gen.html OnlineShop.Content ProductDetail product_details --no-schema --no-default-actions --actions render
  mix scribe.gen.html OnlineShop.Content Cart carts --no-schema --no-default-actions --actions render
  mix scribe.gen.html OnlineShop.Content Checkout checkouts --no-schema --no-default-actions --actions render

  # Catalog
  mix scribe.gen.html OnlineShop.Catalog Category categories name:string desc:string
  mix scribe.gen.html OnlineShop.Catalog FeaturedCategory featured_categories
  mix scribe.gen.html OnlineShop.Catalog Product products name:string desc:string price:integer
  mix scribe.gen.html OnlineShop.Catalog FeaturedProduct featured_products name:string desc:string price:integer

  # SALES
  mix scribe.gen.html OnlineShop.Sales Order orders cart_uuid:references:carts payment_uuid:references:payments shipment_uuid:references:shipments
  mix scribe.gen.html OnlineShop.Sales Cart carts products:array:uuid

  # SHIPPING
  mix scribe.gen.html OnlineShop.Shipping Return returns name:string desc:string
  mix scribe.gen.html OnlineShop.Shipping Delivery deliveries name:string desc:string


  # BILLING
  # mix scribe.gen.html OnlineShop.Billing Invoice invoices name:string desc:string
  # mix scribe.gen.html OnlineShop.Billing CreditSlip credit_slips name:string desc:string
  # mix scribe.gen.html OnlineShop.Billing DeliverySlip delivery_slips name:string desc:string

  # Support
  # mix scribe.gen.html OnlineShop.Support Customer customers name:string desc:string
  # mix scribe.gen.html OnlineShop.Support Business businesses name:string desc:string

  # Internationalization
  # mix scribe.gen.html Internationalization.Inventory Stock stocks name:string desc:string

  # WAREWOUSE
  # mix scribe.gen.html Warehouse.Inventory Stock stocks name:string desc:string

  # BLOG
  # mix scribe.gen.html Blog.Content Post posts name:string desc:string
  # mix scribe.gen.html Blog.Content Comment comments name:string desc:string
  # mix scribe.gen.html Blog.Content Author authors name:string desc:string
}

Blog_Site() {
  Maybe_Create_App

  # BLOG SITE PAGES
  mix scribe.gen.html Blog.Site.Page Home home --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Page PostsLists posts_lists --no-schema --no-default-actions --actions list
  # mix scribe.gen.html Blog.Page Post posts --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Page About about --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Page Portfolio portfolio --no-schema --no-default-actions --actions render

# BLOG ADMIN PAGES
  mix scribe.gen.html Blog.Admin.Page Home home --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Admin.Page PostsLists posts_lists --no-schema --no-default-actions --actions list
  # mix scribe.gen.html Blog.Admin.Page Post posts --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Admin.Page About about --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Admin.Page Portfolio portfolio --no-schema --no-default-actions --actions render

  # # BLOG CONTENT
  # mix scribe.gen.domain Blog.Admin.Content Author authors name short_bio:text
  # mix scribe.gen.domain Blog.Admin.Content Post posts title description content author_uuid:references:authors
  # mix scribe.gen.domain Blog.Admin.Content FeaturedPost featured_posts post_uuid:references:posts
  # mix scribe.gen.domain Blog.Admin.Content RelatedPost related_posts post_uuid:references:posts
  # mix scribe.gen.domain Blog.Admin.Content PostSequence posts_sequences title description posts_uuids:array:uuid


}


Main() {
  local APP_DIRNAME="my_app"
  local TARGET_DIR=".local"

  for input in "${@}"; do
    case "${input}" in
      --dir )
        shift 1
        TARGET_DIR="${1}"
        ;;
    esac
  done

  # Online_Shop
  Blog_Site
}

Main "${@}"
