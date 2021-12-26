module Spree
  module Admin
    class YotpoSettingsController < ResourceController
      
      def index
        @stores = @stores.ransack({ name_or_domains_or_code_cont: params[:q] }).result if params[:q]
        @stores = @stores.where(id: params[:ids].split(',')) if params[:ids]
    
        respond_with(@stores) do |format|
          format.html
          format.json
        end
      end
    

      def create
        yotpo_setting_attributes
        if @yotpo_setting.save
          begin
            ::SpreeYotpoEcommerce::CreateStoreJob.perform_now(@yotpo_setting)
            ::SpreeYotpoEcommerce::UploadStoreContentJob.perform_later
            @yotpo_setting.update(yotpo_account_name: @yotpo_setting.accout_name)
            redirect_to edit_admin_yotpo_setting_path(model_class.first.id)
          rescue Gibbon::YotpoError => e
            flash.now[:error] = e.detail
            render :new
          end
        else
          flash[:error] = @yotpo_setting.errors.full_messages.to_sentence
          render :new
        end
      end

      def update
        @yotpo_setting = YotpoSetting.find(params[:id])
        ActiveRecord::Base.transaction do
          @yotpo_setting.update(permitted_params)
          ::SpreeYotpoEcommerce::UpdateStoreJob.perform_later(@yotpo_setting)
        end
        redirect_to edit_admin_yotpo_setting_path
      end

      def destroy
        @yotpo_setting = YotpoSetting.find(params[:id])
        ActiveRecord::Base.transaction do
          ::SpreeYotpoEcommerce::DeleteStoreJob.perform_now
          @yotpo_setting.destroy
        end
        redirect_to new_admin_yotpo_setting_path
      end

      private

      def model_class
        @model_class ||= ::YotpoSetting
      end

      def permitted_params
        params.require(:yotpo_setting).permit(:yotpo_api_key, :yotpo_list_id, :yotpo_store_name, :yotpo_store_email)
      end

      def yotpo_setting_attributes
        @yotpo_setting = YotpoSetting.new(permitted_params)
        @yotpo_setting.yotpo_store_id = @yotpo_setting.create_store_id
        @yotpo_setting.cart_url = "#{::Rails.application.routes.url_helpers.spree_url}cart"
      end
    end
  end
end
