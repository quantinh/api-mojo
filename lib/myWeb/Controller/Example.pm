package myWeb::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub welcome ($self) {

  # Render template "example/welcome.html.ep" with message
  # Hiển thị ra thư mục template "example/welcome.html.ep" với message
  $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

1;
