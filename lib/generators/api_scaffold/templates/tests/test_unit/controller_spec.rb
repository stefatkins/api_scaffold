require 'test_helper'

<% module_namespacing do -%>
class <%= prefixed_controller_class_name %>ControllerTest < ActionDispatch::IntegrationTest
  <%- if mountable_engine? -%>
  include Engine.routes.url_helpers

  <%- end -%>
  setup do
    @<%= singular_table_name %> = <%= fixture_name %>(:one)
  end

  test "should get index" do
    get <%= ['api', prefix, index_helper].join('_') %>_url, as: :json
    assert_response :success
  end

  test "should create <%= singular_table_name %>" do
    assert_difference('<%= class_name %>.count') do
      post <%= ['api', prefix, index_helper].join('_') %>_url, params: { <%= "#{singular_table_name}: { #{attributes_string} }" %> }, as: :json
    end

    assert_response 201
  end

  test "should show <%= singular_table_name %>" do
    get <%= ['api', prefix, show_helper].join('_') %>, as: :json
    assert_response :success
  end

  test "should update <%= singular_table_name %>" do
    patch <%= ['api', prefix, show_helper].join('_') %>, params: { <%= "#{singular_table_name}: { #{attributes_string} }" %> }, as: :json
    assert_response 200
  end

  test "should destroy <%= singular_table_name %>" do
    assert_difference('<%= class_name %>.count', -1) do
      delete <%= ['api', prefix, show_helper].join('_') %>, as: :json
    end

    assert_response 204
  end
end
<% end -%>
