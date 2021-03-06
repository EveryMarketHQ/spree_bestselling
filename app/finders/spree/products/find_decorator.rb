module Spree
  module Products
    module FindDecorator

      private

      def ordered(products)
        return products unless sort_by?

        case sort_by
        when 'default', 'bestselling'
          # if taxons?
          #   products.ascend_by_taxons_min_position(taxons)
          # else
          #   products
          # end
          products.order(conversions: :desc)
        when 'name-a-z'
          products.order(name: :asc)
        when 'name-z-a'
          products.order(name: :desc)
        when 'newest-first'
          products.order(available_on: :desc)
        when 'price-high-to-low'
          products.
              select("#{Product.table_name}.*, #{Spree::Price.table_name}.amount").
              reorder('').
              send(:descend_by_master_price)
        when 'price-low-to-high'
          products.
              select("#{Product.table_name}.*, #{Spree::Price.table_name}.amount").
              reorder('').
              send(:ascend_by_master_price)
        end
      end
    end
  end
end
::Spree::Products::Find.prepend Spree::Products::FindDecorator
