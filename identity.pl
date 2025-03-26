package identity;

use JSON;
use MIME::Base64;

sub set_identity_header {
    my $identity;
    my $r = shift;

    my $auth_type = $r->header_in("x-auth-type") || "";
    my $org_id = $r->header_in("x-org-id") || $r->variable("env_org_id");

    my $cert_template = decode_json($r->variable("cert_template"));
    my $jwt_template = decode_json($r->variable("jwt_template"));

    if (!$org_id || $org_id eq "") {
        $org_id = $ENV{"ORG_ID"};
    }

    if($auth_type eq "cert-auth") {
        $cert_template->{identity}->{system}->{cn} = $r->header_in("x-cn") || "unknown";
        $cert_template->{identity}->{org_id} = $org_id || "unknown";
        $cert_template->{identity}->{internal}->{org_id} = $org_id || "unknown";
        $identity = encode_json($cert_template);
    }
    elsif ($auth_type eq "jwt-auth") {
        my $user_json_b64 = $r->header_in("x-user") || "e30=";
        my $user_json = decode_base64($user_json_b64);
        my $user_data = decode_json($user_json);

        $jwt_template->{identity}->{user}->{username} = $user_data->{username} || "unknown";
        $jwt_template->{identity}->{user}->{email} = $user_data->{email} || "unknown";
        $jwt_template->{identity}->{user}->{first_name} = $user_data->{first_name} || "unknown";
        $jwt_template->{identity}->{user}->{last_name} = $user_data->{last_name} || "unknown";
        $jwt_template->{identity}->{org_id} = $org_id || "unknown";
        $jwt_template->{identity}->{internal}->{org_id} = $org_id || "unknown";
        $identity = encode_json($jwt_template);
    }
    else {
        $identity = "{}";
    }
    return $identity;
}

1;
