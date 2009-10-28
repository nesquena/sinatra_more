require 'helper'
require 'fixtures/markup_app/app'

class TestFormBuilder < Test::Unit::TestCase
  include SinatraMore::FormHelpers

  def app
    MarkupDemo.tap { |app| app.set :environment, :test }
  end

  def setup
    @user = stub(:errors => stub(:full_messages => ["1", "2"], :none? => false), :class => 'User', :first_name => "Joe", :session_id => 54)
    @user_none = stub(:errors => stub(:none? => true), :class => 'User')
  end

  def standard_builder(object=@user)
    StandardFormBuilder.new(self, object)
  end

  context 'for #form_for method' do
    should "display correct form html" do
      actual_html = form_for(@user, '/register', :id => 'register', :method => 'post') { "Demo" }
      assert_has_tag('form', :action => '/register', :id => 'register', :method => 'post', :content => "Demo") { actual_html }
      assert_has_tag('form input[type=hidden]', :name => '_method', :count => 0) { actual_html } # no method action field
    end

    should "display correct form html with method :post" do
      actual_html = form_for(@user, '/update', :method => 'put') { "Demo" }
      assert_has_tag('form', :action => '/update', :method => 'post') { actual_html }
      assert_has_tag('form input', :type => 'hidden', :name => "_method", :value => 'put') { actual_html }
    end

    should "display correct form html with method :delete" do
      actual_html = form_for(@user, '/destroy', :method => 'delete') { "Demo" }
      assert_has_tag('form', :action => '/destroy', :method => 'post') { actual_html }
      assert_has_tag('form input', :type => 'hidden', :name => "_method", :value => 'delete') { actual_html }
    end

    should "display correct form html with multipart" do
      actual_html = form_for(@user, '/register', :multipart => true) { "Demo" }
      assert_has_tag('form', :action => '/register', :enctype => "multipart/form-data") { actual_html }
    end

    should "support changing form builder type" do
      form_html = lambda { form_for(@user, '/register', :builder => "AbstractFormBuilder") { |f| f.text_field_block(:name) } }
      assert_raise(NoMethodError) { form_html.call }
    end

    should "support using default standard builder" do
      actual_html = form_for(@user, '/register') { |f| f.text_field_block(:name) }
      assert_has_tag('form p input[type=text]') { actual_html }
    end

    should "display correct form in haml" do
      visit '/haml/form_for'
      assert_have_selector :form, :action => '/demo', :id => 'demo'
      assert_have_selector :form, :action => '/another_demo', :id => 'demo2', :method => 'get'
    end

    should "display correct form in erb" do
      visit '/erb/form_for'
      assert_have_selector :form, :action => '/demo', :id => 'demo'
      assert_have_selector :form, :action => '/another_demo', :id => 'demo2', :method => 'get'
    end
  end

  # ===========================
  # AbstractFormBuilder
  # ===========================

  context 'for #error_messages method' do
    should "display correct form html with no record" do
      actual_html = standard_builder(@user_none).error_messages(:header_message => "Demo form cannot be saved")
      assert actual_html.blank?
    end

    should "display correct form html with valid record" do
      actual_html = standard_builder.error_messages(:header_message => "Demo form cannot be saved")
      assert_has_tag('div.field-errors p', :content => "Demo form cannot be saved") { actual_html }
      assert_has_tag('div.field-errors ul.errors-list li', :content => "1") { actual_html }
      assert_has_tag('div.field-errors ul.errors-list li', :content => "2") { actual_html }
    end

    should "display correct form in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo div.field-errors p', :content => "custom MarkupUser cannot be saved!"
      assert_have_selector '#demo div.field-errors ul.errors-list li', :content => "This is a fake error"
      assert_have_selector '#demo2 div.field-errors p', :content => "custom MarkupUser cannot be saved!"
      assert_have_selector '#demo2 div.field-errors ul.errors-list li', :content => "This is a fake error"
    end

    should "display correct form in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo div.field-errors p', :content => "custom MarkupUser cannot be saved!"
      assert_have_selector '#demo div.field-errors ul.errors-list li', :content => "This is a fake error"
      assert_have_selector '#demo2 div.field-errors p', :content => "custom MarkupUser cannot be saved!"
      assert_have_selector '#demo2 div.field-errors ul.errors-list li', :content => "This is a fake error"
    end
  end

  context 'for #label method' do
    should "display correct label html" do
      actual_html = standard_builder.label(:first_name, :class => 'large', :caption => "F. Name")
      assert_has_tag('label', :class => 'large', :for => 'user_first_name', :content => "F. Name: ") { actual_html }
    end

    should "display correct label in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo label', :content => "Login: ", :class => 'user-label'
      assert_have_selector '#demo label', :content => "About Me: "
      assert_have_selector '#demo2 label', :content => "Nickname: ", :class => 'label'
    end

    should "display correct label in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo label', :content => "Login: ", :class => 'user-label'
      assert_have_selector '#demo label', :content => "About Me: "
      assert_have_selector '#demo2 label', :content => "Nickname: ", :class => 'label'
    end
  end

  context 'for #hidden_field method' do
    should "display correct hidden field html" do
      actual_html = standard_builder.hidden_field(:session_id, :class => 'hidden')
      assert_has_tag('input.hidden[type=hidden]', :value => "54", :id => 'user_session_id', :name => 'user[session_id]') { actual_html }
    end

    should "display correct hidden field in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo input[type=hidden]', :id => 'markup_user_session_id', :value => "45"
      assert_have_selector '#demo2 input', :type => 'hidden', :name => 'markup_user[session_id]'
    end

    should "display correct hidden field in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo input[type=hidden]', :id => 'markup_user_session_id', :value => "45"
      assert_have_selector '#demo2 input', :type => 'hidden', :name => 'markup_user[session_id]'
    end
  end

  context 'for #text_field method' do
    should "display correct text field html" do
      actual_html = standard_builder.text_field(:first_name, :class => 'large')
      assert_has_tag('input.large[type=text]', :value => "Joe", :id => 'user_first_name', :name => 'user[first_name]') { actual_html }
    end

    should "display correct text field in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo input.user-text[type=text]', :id => 'markup_user_username', :value => "John"
      assert_have_selector '#demo2 input', :type => 'text', :class => 'input', :name => 'markup_user[username]'
    end

    should "display correct text field in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo input.user-text[type=text]', :id => 'markup_user_username', :value => "John"
      assert_have_selector '#demo2 input', :type => 'text', :class => 'input', :name => 'markup_user[username]'
    end
  end

  context 'for #check_box method' do
    should "display correct checkbox html" do
      actual_html = standard_builder.check_box(:confirm_destroy, :class => 'large')
      assert_has_tag('input.large[type=checkbox]', :id => 'user_confirm_destroy', :name => 'user[confirm_destroy]') { actual_html }
      assert_has_tag('input[type=hidden]', :name => 'user[confirm_destroy]', :value => '0') { actual_html }
    end

    should "display correct checkbox html when checked" do
      actual_html = standard_builder.check_box(:confirm_destroy, :checked => true)
      assert_has_tag('input[type=checkbox]', :checked => 'checked', :name => 'user[confirm_destroy]') { actual_html }
    end

    should "display correct checkbox html as checked when object value matches" do
      @user.stubs(:show_favorites => '1')
      actual_html = standard_builder.check_box(:show_favorites, :value => '1')
      assert_has_tag('input[type=checkbox]', :checked => 'checked', :name => 'user[show_favorites]') { actual_html }
    end

    should "display correct checkbox html as unchecked when object value doesn't match" do
      @user.stubs(:show_favories => '0')
      actual_html = standard_builder.check_box(:show_favorites, :value => 'female')
      assert_has_no_tag('input[type=checkbox]', :checked => 'checked') { actual_html }
    end

    should "display correct unchecked hidden field when specified" do
      actual_html = standard_builder.check_box(:show_favorites, :value => 'female', :uncheck_value => 'false')
      assert_has_tag('input[type=hidden]', :name => 'user[show_favorites]', :value => 'false') { actual_html }
    end

    should "display correct checkbox in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo input[type=checkbox]', :checked => 'checked', :id => 'markup_user_remember_me', :name => 'markup_user[remember_me]'
    end

    should "display correct checkbox in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo input[type=checkbox]', :checked => 'checked', :id => 'markup_user_remember_me', :name => 'markup_user[remember_me]'
    end
  end

  context 'for #radio_button method' do
    should "display correct radio button html" do
      actual_html = standard_builder.radio_button(:gender, :value => 'male', :class => 'large')
      assert_has_tag('input.large[type=radio]', :id => 'user_gender_male', :name => 'user[gender]', :value => 'male') { actual_html }
    end

    should "display correct radio button html when checked" do
      actual_html = standard_builder.radio_button(:gender, :checked => true)
      assert_has_tag('input[type=radio]', :checked => 'checked', :name => 'user[gender]') { actual_html }
    end

    should "display correct radio button html as checked when object value matches" do
      @user.stubs(:gender => 'male')
      actual_html = standard_builder.radio_button(:gender, :value => 'male')
      assert_has_tag('input[type=radio]', :checked => 'checked', :name => 'user[gender]') { actual_html }
    end

    should "display correct radio button html as unchecked when object value doesn't match" do
      @user.stubs(:gender => 'male')
      actual_html = standard_builder.radio_button(:gender, :value => 'female')
      assert_has_no_tag('input[type=radio]', :checked => 'checked') { actual_html }
    end

    should "display correct radio button in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo input[type=radio]', :id => 'markup_user_gender_male', :name => 'markup_user[gender]', :value => 'male'
      assert_have_selector '#demo input[type=radio]', :id => 'markup_user_gender_female', :name => 'markup_user[gender]', :value => 'female'
      assert_have_selector '#demo input[type=radio][checked=checked]', :id => 'markup_user_gender_male'
    end

    should "display correct radio button in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo input[type=radio]', :id => 'markup_user_gender_male', :name => 'markup_user[gender]', :value => 'male'
      assert_have_selector '#demo input[type=radio]', :id => 'markup_user_gender_female', :name => 'markup_user[gender]', :value => 'female'
      assert_have_selector '#demo input[type=radio][checked=checked]', :id => 'markup_user_gender_male'
    end
  end

  context 'for #text_area method' do
    should "display correct text_area html" do
      actual_html = standard_builder.text_area(:about, :class => 'large')
      assert_has_tag('textarea.large', :id => 'user_about', :name => 'user[about]') { actual_html }
    end

    should "display correct text_area in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'user-about'
      assert_have_selector '#demo2 textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'textarea'
    end

    should "display correct text_area in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'user-about'
      assert_have_selector '#demo2 textarea', :name => 'markup_user[about]', :id => 'markup_user_about', :class => 'textarea'
    end
  end

  context 'for #password_field method' do
    should "display correct password_field html" do
      actual_html = standard_builder.password_field(:code, :class => 'large')
      assert_has_tag('input.large[type=password]', :id => 'user_code', :name => 'user[code]') { actual_html }
    end

    should "display correct password_field in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo input', :type => 'password', :class => 'user-password', :value => 'secret'
      assert_have_selector '#demo2 input', :type => 'password', :class => 'input', :name => 'markup_user[code]'
    end

    should "display correct password_field in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo input', :type => 'password', :class => 'user-password', :value => 'secret'
      assert_have_selector '#demo2 input', :type => 'password', :class => 'input', :name => 'markup_user[code]'
    end
  end

  context 'for #file_field method' do
    should "display correct file_field html" do
      actual_html = standard_builder.file_field(:photo, :class => 'large')
      assert_has_tag('input.large[type=file]', :id => 'user_photo', :name => 'user[photo]') { actual_html }
    end

    should "display correct file_field in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo  input.user-photo', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'
      assert_have_selector '#demo2 input.upload', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'
    end

    should "display correct file_field in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo  input.user-photo', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'
      assert_have_selector '#demo2 input.upload', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'
    end
  end

  context 'for #submit method' do
    should "display correct submit button html with no options" do
      actual_html = standard_builder.submit
      assert_has_tag('input[type=submit]', :value => "Submit") { actual_html }
    end

    should "display correct submit button html" do
      actual_html = standard_builder.submit("Commit", :class => 'large')
      assert_has_tag('input.large[type=submit]', :value => "Commit") { actual_html }
    end

    should "display correct submit button in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo input', :type => 'submit', :id => 'demo-button', :class => 'success'
      assert_have_selector '#demo2 input', :type => 'submit', :class => 'button', :value => "Create"
    end

    should "display correct submit button in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo input', :type => 'submit', :id => 'demo-button', :class => 'success'
      assert_have_selector '#demo2 input', :type => 'submit', :class => 'button', :value => "Create"
    end
  end

  # ===========================
  # StandardFormBuilder
  # ===========================

  context 'for #text_field_block method' do
    should "display correct text field block html" do
      actual_html = standard_builder.text_field_block(:first_name, :class => 'large', :caption => "FName")
      assert_has_tag('p label', :for => 'user_first_name', :content => "FName: ") { actual_html }
      assert_has_tag('p input.large[type=text]', :value => "Joe", :id => 'user_first_name', :name => 'user[first_name]') { actual_html }
    end

    should "display correct text field block in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo2 p label', :for => 'markup_user_username', :content => "Nickname: ", :class => 'label'
      assert_have_selector '#demo2 p input', :type => 'text', :name => 'markup_user[username]', :id => 'markup_user_username'
    end

    should "display correct text field block in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo2 p label', :for => 'markup_user_username', :content => "Nickname: ", :class => 'label'
      assert_have_selector '#demo2 p input', :type => 'text', :name => 'markup_user[username]', :id => 'markup_user_username'
    end
  end

  context 'for #text_area_block method' do
    should "display correct text area block html" do
      actual_html = standard_builder.text_area_block(:about, :class => 'large', :caption => "About Me")
      assert_has_tag('p label', :for => 'user_about', :content => "About Me: ") { actual_html }
      assert_has_tag('p textarea', :id => 'user_about', :name => 'user[about]') { actual_html }
    end

    should "display correct text area block in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo2 p label', :for => 'markup_user_about', :content => "About: "
      assert_have_selector '#demo2 p textarea', :name => 'markup_user[about]', :id => 'markup_user_about'
    end

    should "display correct text area block in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo2 p label', :for => 'markup_user_about', :content => "About: "
      assert_have_selector '#demo2 p textarea', :name => 'markup_user[about]', :id => 'markup_user_about'
    end
  end

  context 'for #password_field_block method' do
    should "display correct password field block html" do
      actual_html = standard_builder.password_field_block(:keycode, :class => 'large', :caption => "Code")
      assert_has_tag('p label', :for => 'user_keycode', :content => "Code: ") { actual_html }
      assert_has_tag('p input.large[type=password]', :id => 'user_keycode', :name => 'user[keycode]') { actual_html }
    end

    should "display correct password field block in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo2 p label', :for => 'markup_user_code', :content => "Code: "
      assert_have_selector '#demo2 p input', :type => 'password', :name => 'markup_user[code]', :id => 'markup_user_code'
    end

    should "display correct password field block in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo2 p label', :for => 'markup_user_code', :content => "Code: "
      assert_have_selector '#demo2 p input', :type => 'password', :name => 'markup_user[code]', :id => 'markup_user_code'
    end
  end

  context 'for #file_field_block method' do
    should "display correct file field block html" do
      actual_html = standard_builder.file_field_block(:photo, :class => 'large', :caption => "Photo")
      assert_has_tag('p label', :for => 'user_photo', :content => "Photo: ") { actual_html }
      assert_has_tag('p input.large[type=file]', :id => 'user_photo', :name => 'user[photo]') { actual_html }
    end

    should "display correct file field block in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo2 p label', :for => 'markup_user_photo', :content => "Photo: "
      assert_have_selector '#demo2 p input.upload', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'
    end

    should "display correct file field block in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo2 p label', :for => 'markup_user_photo', :content => "Photo: "
      assert_have_selector '#demo2 p input.upload', :type => 'file', :name => 'markup_user[photo]', :id => 'markup_user_photo'
    end
  end

  context 'for #submit_block method' do
    should "display correct submit block html" do
      actual_html = standard_builder.submit_block("Update", :class => 'large')
      assert_has_tag('p input.large[type=submit]', :value => 'Update') { actual_html }
    end

    should "display correct submit block in haml" do
      visit '/haml/form_for'
      assert_have_selector '#demo2 p input', :type => 'submit', :class => 'button'
    end

    should "display correct submit block in erb" do
      visit '/erb/form_for'
      assert_have_selector '#demo2 p input', :type => 'submit', :class => 'button'
    end
  end
end
