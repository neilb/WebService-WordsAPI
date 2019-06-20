package WebService::WordsAPI;

use 5.006;
use Moo;
use JSON::MaybeXS;

has key => (
    is       => 'ro',
    required => 1,
);

has ua => (
    is      => 'ro',
    default => sub {
                   require HTTP::Tiny;
                   require IO::Socket::SSL;
                   return HTTP::Tiny->new;
               },
);

has base_url => (
    is      => 'ro',
    default => sub { 'https://wordsapiv1.p.mashape.com/words' },
);

has return_type => (
    is      => 'ro',
    default => sub { 'perl' },
);

sub _request
{
    my ($self, $relurl) = @_;
    my $url             = $self->base_url.'/'.$relurl;
    my $headers         = {
                             "X-Mashape-Key" => $self->key,
                             "Accept"        => "application/json",
                          };
    my $response        = $self->ua->get($url, { headers => $headers });

    if (not $response->{success}) {
        die "failed $response->{status} $response->{reason}\n";
    }

    return $self->return_type eq 'json'
           ? $response->{content}
           : decode_json($response->{content})
           ;
}

sub get_word_details
{
    my ($self, $word) = @_;

    return $self->_request($word);
}

sub rhymes_with
{
    my ($self, $word) = @_;

    return $self->_request($word.'/rhymes');
}

1;


