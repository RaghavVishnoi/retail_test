$('#module-activation-link-<%= @module_group.id %>').replaceWith('<%= j(render :partial => "activation_link", :locals => { :group => @module_group }) %>')