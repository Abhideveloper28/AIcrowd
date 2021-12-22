ActiveAdmin.register Setting do
  config.clear_action_items!

  controller do
    def permitted_params
      params.permit!
    end
  end

  form do |f|
    f.inputs do
      f.input :jobs_visible
      panel 'Home Page' do
        f.input :home_page_social_image, :as => :file, :hint => link_to("Current Image", f.object.home_page_social_image.url)
      end
      panel 'Header Banner' do
        f.input :enable_banner
        f.input :banner_text
        f.input :banner_color
      end
      panel 'Footer' do
        f.input :enable_footer
        f.input :footer_text
      end

      panel 'Weekly Popup' do
        f.input :weekly_popup_title
        f.input :weekly_popup_subtitle
        f.input :weekly_popup_description
        f.input :weekly_popup_link
        f.input :weekly_popup_button
        f.input :weekly_popup_start_date
        f.input :weekly_popup_end_date
      end
      f.actions
    end
  end

  action_item :create, only: :index do
    link_to 'Create Setting', new_admin_setting_path unless Setting.first.present?
  end
end
