use JSON;

sub set_identity_header {
    my $r = shift;

    my $auth_type = $r->header_in("x-auth-type") || "";
    my $org_id = $r->header_in("x-org-id") || $r->variable("env_org_id");

    my $cert_template = decode_json($r->variable("cert_template"));
    my $jwt_template =decode_json($r->variable("jwt_template"));

    my $identity;

    if($auth_type eq "cert-auth") {
        $cert_template->{cn} = $r->header_in("x-cn") || "unknown";
        $cert_template->{org_id} = $org_id || "unknown";
        $identity = encode_json($cert_template);
    }
    elsif ($auth_type eq "jwt-auth") {
        my $user_json = r->header_in("x-user") || "{}";
        my $user_data = decode_json($user_json);

        $jwt_template->{username} = $user_data->{username} || "unknown";
        $jwt_template->{email} = $user_data->{email} || "unknown";
        $jwt_template->{first_name} = $user_data->{first_name} || "unknown";
        $jwt_template->{last_name} = $user_data->{last_name} || "unknown";
        $jwt_template->{org_id} = $org_id || "unknown";
        $identity = encode_json($jwt_template);
    }
    else {
        $identity = "{}";
    }

    r->header_out("x-rh-identity", $identity);
    return NGX_OK;
}

1;
