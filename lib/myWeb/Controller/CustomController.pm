package myWeb::Controller::CustomController;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use DBI;
use strict;
use HTML::Entities;
use Encode;


# Action welcome render dữ liệu ra template
sub welcome ($self) {

  # Hiển thị ra thư mục template "example/welcome.html.ep" với message
  # $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');

  # Hiển thị ra thư mục template "example/welcome.html.ep" với message
  $self->render(
      template => 'myTemplates/home',
      msg      => 'Welcome to My personal website !'
  );
}
# Action showData
sub show($self) {
  my $driver    = "Pg"; 
  my $database  = "learning-perl";
  my $dsn       = "DBI:Pg:dbname = learning-perl; host = localhost; port = 5432";
  my $userid    = "postgres";
  my $password  = "123456";
  my $dbh       =  DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;
  print "Connect database successfully\n";
  my $query = 
  qq(
    SELECT *
    FROM actor
    ORDER BY actor_id DESC
    LIMIT 5
    ;
  );
  # Thực hiện câu query trên
  my $sth = $dbh->prepare($query);
  # Hiển thị lỗi nếu sai 
  my $rv = $sth->execute() or die $DBI::errstr;
  # Hiển thị số phần tử lấy ra 
  if($rv < 0) {
    print $DBI::errstr;
  }
  print "Operation done successfully\n";
  my @rows;
  while (my $row = $sth->fetchrow_hashref) {
    push @rows, $row;
  }
  $sth->finish();
  $dbh->disconnect();
  $self->render(
    rows      => \@rows,
    template  => "myTemplates/list"
  );
  return;
}
# Action formAdd
sub fromAdd($self) {
  $self->render(
    template => 'myTemplates/add'
  );
}
# Action Add
sub add($self) {
  my $driver    = "Pg"; 
  my $database  = "learning-perl";
  my $dsn       = "DBI:Pg:dbname = learning-perl; host = localhost; port = 5432";
  my $userid    = "postgres";
  my $password  = "123456";
  my $dbh       =  DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;
  print "Connect database successfully\n";

  my $first_name = $self->param('first_name');
  my $last_name = $self->param('last_name');
  my $last_update = $self->param('last_update');

  my $query = 
  qq(
    INSERT INTO 
    actor (first_name, last_name, last_update) 
    VALUES ('$first_name', '$last_name', NOW());
  );
  # Thực hiện câu query trên
  my $sth = $dbh->prepare($query);
  # Hiển thị lỗi nếu sai 
  my $rv = $sth->execute() or die $DBI::errstr;
  # Hiển thị số phần tử lấy ra 
  if($rv < 0) {
    print $DBI::errstr;
  }
  print "Operation done successfully\n";
  $sth->finish();
  $dbh->disconnect();
  $self->redirect_to('/');
  return;
}
# Action formDelete
sub delete($self) {
  my $driver    = "Pg"; 
  my $database  = "learning-perl";
  my $dsn       = "DBI:Pg:dbname = learning-perl; host = localhost; port = 5432";
  my $userid    = "postgres";
  my $password  = "123456";
  my $dbh       =  DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;
  print "Connect database successfully\n";
  my $id = $self->stash('id');
  my $query = 
  qq(
    DELETE FROM actor   
    WHERE 
    actor_id = $id; 
  );
  my $sth = $dbh->prepare($query);
  my $rv = $sth->execute() or die $DBI::errstr;
  $self->redirect_to('/');
}
# Action formEdit
sub formUpdate($self) {
  my $driver    = "Pg"; 
  my $database  = "learning-perl";
  my $dsn       = "DBI:Pg:dbname = learning-perl; host = localhost; port = 5432";
  my $userid    = "postgres";
  my $password  = "123456";
  my $dbh       =  DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;
  print "Connect database successfully\n";

  my $id = $self->stash('id');
  my $query = 
  qq(
    SELECT * 
    FROM actor 
    WHERE actor_id = $id 
    LIMIT 1
  );  

  my $sth = $dbh->prepare($query);
  my $rv = $sth->execute() or die $DBI::errstr;
  my @rows;
  while (my $row = $sth->fetchrow_hashref) {
    push @rows, $row;
  }
  $self->render(
    rows => \@rows,
    template => 'myTemplates/update'
  );
}
# Action formEdit
sub update ($self) {
  my $driver    = "Pg"; 
  my $database  = "learning-perl";
  my $dsn       = "DBI:Pg:dbname = learning-perl; host = localhost; port = 5432";
  my $userid    = "postgres";
  my $password  = "123456";
  my $dbh       =  DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) or die $DBI::errstr;
  print "Connect database successfully\n";

  my $id = $self->stash('id');
  my $first_name = $self->param('first_name');
  my $last_name = $self->param('last_name');

  my $query = 
  qq(
    UPDATE actor 
    SET 
    first_name = '$first_name',
    last_name = '$last_name'
    WHERE actor_id = $id
  );

  my $sth = $dbh->prepare($query);
  my $rv = $sth->execute() or die $DBI::errstr;
  $self->redirect_to('/');
}
1;
