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

Scribe_Domain_Criteria_1() {
  mix scribe.gen.domain Sales.Catalog Category categories name:string desc:string
}

Scribe_Domain_Criteria_2() {
  mix scribe.gen.domain Sales.Catalog Product products sku:string name:string desc:string --actions import,export
}

Scribe_Domain_Criteria_3() {
  mix scribe.gen.html Warehouse.Fulfillment FulfillmentOrder fulfillment_orders uuid:string label:string total_quantity:integer location:string products_sku:array:string --no-default-actions --actions list
}

Scribe_Html_Criteria_1() {
  mix scribe.gen.html Sales.Catalog Category categories name:string desc:string
}

Scribe_Html_Criteria_2() {
  mix scribe.gen.html Sales.Catalog Product products sku:string name:string desc:string --actions import,export
}

Scribe_Html_Criteria_3() {
  mix scribe.gen.html Warehouse.Fulfillment FulfillmentOrder fulfillment_orders uuid:string label:string total_quantity:integer location:string products_sku:array:string --no-default-actions --actions list
}

Todo_App() {
  Maybe_Create_App

  mix scribe.gen.html Todo Task tasks title:string done:boolean
  mix scribe.gen.html Todo Tag tags title:string desc:string
  mix scribe.gen.html Acounts User users name:string email:string
}

Shop_App() {
  Maybe_Create_App

  # Sales Catalog
  mix scribe.gen.html Sales.Catalog Category categories name:string desc:string
  mix scribe.gen.html Sales.Catalog Product products sku:string name:string desc:string price:integer vat:integer --actions import,export
  # mix scribe.gen.html Sales.Catalog Cart carts total_amount:integer total_quantity:integer products_skus:array:string --actions report

  # Sales Checkout
  # mix scribe.gen.domain Sales.Checkout CheckoutProduct checkout_products sku:string name:string desc:string --no-default-actions --actions build
  mix scribe.gen.html Sales.Checkout Order orders total_amount:integer total_quantity:integer products_skus:array:string cart_uuid:string shipping_uuid:string --actions report

  # Sales Billing
  # mix scribe.gen.domain Sales.Billing BillingProduct billing_products sku:string quantity:integer cost_per_unit:integer --no-default-actions --actions build

  # Warehouse Fulfillment
  mix scribe.gen.domain Warehouse.Fulfillment FulfillmentProduct fulfillment_products sku:string label:string total_quantity:integer location:string --no-default-actions --actions build
  # mix scribe.gen.html Warehouse.Shipment Parcel parcels pickup_datetime:datetime label:string carrier_uuid:string
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
  mix scribe.gen.html Blog.Site Home home --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Page PostsLists posts_lists --no-schema --no-default-actions --actions list
  # mix scribe.gen.html Blog.Page Post posts --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Page About about --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Page Portfolio portfolio --no-schema --no-default-actions --actions render

  # BLOG ADMIN PAGES
  mix scribe.gen.html Blog.Admin Home home --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Admin.Page PostsLists posts_lists --no-schema --no-default-actions --actions list
  # mix scribe.gen.html Blog.Admin.Page Post posts --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Admin.Page About about --no-schema --no-default-actions --actions render
  # mix scribe.gen.html Blog.Admin.Page Portfolio portfolio --no-schema --no-default-actions --actions render

  # # BLOG CONTENT
  mix scribe.gen.domain Blog.Admin.Content Author authors name short_bio:text
  # mix scribe.gen.domain Blog.Admin.Content Post posts title description content author_uuid:references:authors
  # mix scribe.gen.domain Blog.Admin.Content FeaturedPost featured_posts post_uuid:references:posts
  # mix scribe.gen.domain Blog.Admin.Content RelatedPost related_posts post_uuid:references:posts
  # mix scribe.gen.domain Blog.Admin.Content PostSequence posts_sequences title description posts_uuids:array:uuid


}


Main() {
  # echo "MIX_ENV: ${MIX_ENV}"
  export MIX_ENV=dev

  local APP_DIRNAME="my_app"
  local TARGET_DIR=".local"

  for input in "${@}"; do
    case "${input}" in
      --dir )
        shift 1
        TARGET_DIR="${1}"
        ;;

      blog )
        Blog_Site
        exit $?
        ;;

      todo )
        Todo_App
        exit $?
        ;;

      shop )
        Shop_App
        exit $?
        ;;

      scribe-domain-criteria-1 )
        Maybe_Create_App
        Scribe_Domain_Criteria_1
        exit $?
        ;;

      scribe-domain-criteria-2 )
        Maybe_Create_App
        Scribe_Domain_Criteria_2
        exit $?
        ;;

      scribe-domain-criteria-3 )
        Maybe_Create_App
        Scribe_Domain_Criteria_3
        exit $?
        ;;

      scribe-domain-criterias )
        Maybe_Create_App
        Scribe_Domain_Criteria_1
        Scribe_Domain_Criteria_2
        Scribe_Domain_Criteria_3
        exit $?
        ;;

      scribe-html-criteria-1 )
        Maybe_Create_App
        Scribe_Html_Criteria_1
        exit $?
        ;;

      scribe-html-criteria-2 )
        Maybe_Create_App
        Scribe_Html_Criteria_2
        exit $?
        ;;

      scribe-html-criteria-3 )
        Maybe_Create_App
        Scribe_Html_Criteria_3
        exit $?
        ;;

      scribe-html-criterias )
        Maybe_Create_App
        Scribe_Html_Criteria_1
        Scribe_Html_Criteria_2
        Scribe_Html_Criteria_3
        exit $?
        ;;
    esac
  done
}

Main "${@}"
