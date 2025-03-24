function setIdetityHeader(r) {
    var authType = r.headersIn['x-auth-type'] || '';
    var orgId = r.headersIn['x-org-id'] || r.variables.env_org_id;

    var certTemplate = JSON.parse(r.variables.cert_template);
    var jwtTemplate = JSON.parse(r.variables.jwt_template);

    var identity;

    if (authType === 'cert-auth') {
        identity = JSON.stringify({
            auth_type: certTemplate.auth_type,
            cn: r.headersIn['x-cn'] || 'unknown',
            org_id: orgId || 'unknown'
        });
    } else if (authType === 'jwt-auth') {
        var userData = {};
        try {
            userData = JSON.parse(r.headersIn['x-user'] || '{}');
        } catch (e) {
            r.warn('Failed to parse x-user header: ' + e);
        }
        identity = JSON.stringify({
            auth_type: jstTemplate.auth_type,
            username: userData.username || 'unknown',
            email: userData.email || 'unknown',
            first_name: userData.first_name || 'unknown',
            last_name: userData.last_name || 'unknown',
            org_id: orgId || 'unknown'            
        });
    } else {
        identity = '{}';
    }

    r.headersOut['x-rh-identity'] = identity;
    return identity;
}

export default { setIdetityHeader };
