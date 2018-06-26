class LoginLicensePage
  include PageObject

  	in_iframe(css: 'div[class="w2ui-panel-content"] iframe') do |iframe|
      file_field(:license_file_form, class: "file-input", frame: iframe)
  		button(:save_form, name: 'save', frame: iframe)
      button(:yes_confirm, id: 'Yes', frame: iframe)
  	end

    def import_license_file(file_path)
      self.save_form_element.wait_until_present
      self.license_file_form = file_path
      self.save_form
      self.yes_confirm_element.wait_until_present.click
      # sleep 1
    end

end
