BEGIN {
  use Config;
  if (! $Config{'useithreads'}) {
      print("1..0 # Skipped: Perl not compiled with 'useithreads'\n");
      exit(0);
  }
}

use strict;

use lib '../lib';
use Text::Editor::Easy;

Text::Editor::Easy->new (
    {
        'x_offset' => 60,
        'y_offset' => 170,
        'width'    => 200,
        'height'   => 200,
    }
);
		
use Test::More qw( no_plan );

my @first_list = threads->list;

my $tid = Text::Editor::Easy->create_new_server(
   {
		'use' => 'Text::Editor::Easy::Test::Test1', 
		'package' => 'Text::Editor::Easy::Test::Test1',
		'methods' => ['test1'], 
		'object' => [] 
	});

my @second_list = threads->list;
is ( scalar(@second_list), scalar(@first_list) + 1, "One more thread");

my @param = ( 3, 'BOF' );
my ( $thread_tid, $_3xparam0, $TEST1_param1 ) = Text::Editor::Easy->test1( @param );
is ( $tid, $thread_tid, "Thread number, first call" );
is ( $_3xparam0, 3 * $param[0], "First return value, first call" );
is ( $TEST1_param1, "TEST1" . $param[1], "Second return value, first call" );

@param = ( 14, 'dslf ds' );
( $thread_tid, $_3xparam0, $TEST1_param1 ) = Text::Editor::Easy->test1( @param );
is ( $tid, $thread_tid, "Thread number, second call" );
is ( $_3xparam0, 3 * $param[0], "First return value, second call" );
is ( $TEST1_param1, "TEST1" . $param[1], "Second return value, second call" );

my $new_tid = Text::Editor::Easy->create_new_server(
   {
		'use' => 'Text::Editor::Easy::Test::Test3', 
		'package' => 'Text::Editor::Easy::Test::Test3',
		'methods' => ['test3', 'test4', 'object_test'], 
		'object' => [23, "rere"] ,
		'name' => 'Test',
	});
my @third_list = threads->list;
is ( scalar(@third_list), scalar(@first_list) + 2, "Still one more thread");

( $thread_tid, $_3xparam0, $TEST1_param1 ) = Text::Editor::Easy->test3( @param );
is ( $thread_tid, $new_tid, "Thread number, third call" );
is ( $_3xparam0, 4 * $param[0], "First return value, third call" );
is ( $TEST1_param1, "TEST3" . $param[1], "Second return value, third call" );

( $_3xparam0, $TEST1_param1 ) = Text::Editor::Easy->object_test( @param );
is ( $_3xparam0, 23 * 12 - 2 * $param[0], "First return value, call 4" );
is ( $TEST1_param1, "rereBOF" . $param[1], "Second return value, call 4" );