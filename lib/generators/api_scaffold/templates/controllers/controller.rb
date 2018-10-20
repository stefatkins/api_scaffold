<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= prefixed_controller_class_name %>Controller < ApplicationController
  before_action :set_<%= singular_table_name %>, only: [:show, :update, :destroy]

  def index
    @<%= plural_table_name %> = <%= 'paginate ' if gem_available?('api-pagination') %><%= orm_class.all(class_name) %>
    render json: <%= "@#{plural_table_name}" %>
  end
  
  def show
    render json: <%= "@#{singular_table_name}" %>
  end

  def create
    @<%= singular_table_name %> = <%= orm_class.build(class_name, "#{singular_table_name}_params") %>

    if @<%= orm_instance.save %>
      render json: <%= "@#{singular_table_name}" %>, status: :created, location: [:api, :<%= prefix %>, <%= "@#{singular_table_name}" %>]
    else
      render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity
    end
  end

  def update
    if @<%= orm_instance.update("#{singular_table_name}_params") %>
      render json: <%= "@#{singular_table_name}" %>
    else
      render json: <%= "@#{orm_instance.errors}" %>, status: :unprocessable_entity
    end
  end

  def destroy
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
