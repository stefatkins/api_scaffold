<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= prefixed_controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :update, :destroy]

  <% if apipie_installed? -%>def_param_group :<%= singular_table_name %> do
    param :<%= singular_table_name %>, Hash, required: true, action_aware: true do
    <% attributes_names.each do |attribute_name| -%><%= indent(apipie_param(attribute_name), 2) %>
    <% end -%>end
  end

  api :GET, '/<%= plural_table_name %>', 'List <%= plural_table_name %>'
  <% if gem_available?('api-pagination') %>param :page, String, 'Paginate results'
  param :per_page, String, 'Number of records per page'
  <% end -%>
  <% end -%>def index
    @<%= plural_table_name %> = <%= 'paginate ' if gem_available?('api-pagination') %><%= orm_class.all(class_name) %>
    render json: <%= "@#{plural_table_name}" %>
  end

  
  <% if apipie_installed? -%>api :GET, '/<%= [prefix, plural_table_name].join("/") %>/:id', 'Show <%= singular_table_name %>'
  <% end -%>def show
    render json: <%= "@#{singular_table_name}" %>
  end

  <% if apipie_installed? -%>api :POST, '/<%= [prefix, plural_table_name].join("/")  %>', 'Create <%= singular_table_name %>'
  param_group :<%= singular_table_name %>
  <% end -%>def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    if @<%= orm_instance.save %>
      render json: <%= "@#{singular_table_name}" %>, status: :created, location: [:api, :<%= prefix %>, <%= "@#{singular_table_name}" %>]
    else
      render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity
    end
  end

  <% if apipie_installed? -%>api :PUT, '/<%= [prefix, plural_table_name].join("/")  %>/:id', 'Update <%= singular_table_name %>'
  param_group :<%= singular_table_name %>
  <% end -%>def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      render json: <%= "@#{singular_table_name}" %>
    else
      render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity
    end
  end

  <% if apipie_installed? -%>api :DELETE, '/<%= [prefix, plural_table_name].join("/")  %>/:id', 'Delete <%= singular_table_name %>'
  <% end -%>def destroy
    @<%= orm_instance.destroy %>
  end

  private

  def set_<%= singular_table_name %>
    @<%= singular_table_name %> = <%= orm_class.find(class_name, "params[:id]") %>
  end

  def <%= "#{singular_table_name}_params" %>
    <%- if attributes_names.empty? -%>
    params.fetch(:<%= singular_table_name %>, {})
    <%- else -%>
    params.require(:<%= singular_table_name %>).permit(<%= attributes_names.map { |name| ":#{name}" }.join(', ') %>)
    <%- end -%>
  end
end
<% end -%>
