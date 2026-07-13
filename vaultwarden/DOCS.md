# Home Assistant Community App: Vaultwarden

Bitwarden is an open-source password manager that can store sensitive
information such as website credentials in an encrypted vault.

The Bitwarden platform offers a variety of client applications including
a web interface, desktop applications, browser extensions and mobile apps.

This app is based upon the lightweight and opensource
[Vaultwarden][vaultwarden] implementation, allowing you to self-host
this amazing password manager.

Password theft is a serious problem. The websites and apps that you use are
under attack every day. Security breaches occur and your passwords are stolen.
When you reuse the same passwords everywhere hackers can easily access your
email, bank, and other important accounts. USE A PASSWORD MANAGER!

## Installation

The installation of this app is pretty straightforward and not different in
comparison to installing any other Home Assistant app.

1. Click the Home Assistant My button below to open the app on your Home
   Assistant instance.

   [![Open this app in your Home Assistant instance.][addon-badge]][addon]

1. Click the "Install" button to install the app.
1. Start the "Vaultwarden" app.
1. Check the logs of the "Vaultwarden" app to see if everything
   went well and to get the admin token/password.
1. Click the "OPEN WEB UI" button to open Vaultwarden.
1. Add `/admin` to the URL to access the admin panel, e.g.,
   `http://hassio.local:7277/admin`. Log in using the admin token you got
   in step 4.
1. The admin/token in the logs is only shown until it is saved or changed.
   Hit save in the admin panel to use the randomly generated password or
   change it to one of your choosing.
1. Be sure to store your admin token somewhere safe. **The app will never
   show it again!**

## Configuration

**Note**: _Remember to restart the app when the configuration is changed._

Example app configuration:

```yaml
log_level: info
ssl: false
certfile: fullchain.pem
keyfile: privkey.pem
request_size_limit: 10485760
domain: https://vaultwarden.example.com
sso_enabled: true
sso_authority: https://authentik.example.com/application/o/vaultwarden/
sso_client_id: myclientid
sso_client_secret: myclientsecret
sso_scopes: email profile offline_access
sso_only: false
sso_signups_match_email: true
env_vars:
  - name: SSO_PKCE
    value: "true"
```

**Note**: _This is just an example, don't copy and paste it! Create your own!_

### Option: `log_level`

The `log_level` option controls the level of log output by the app and can
be changed to be more or less verbose, which might be useful when you are
dealing with an unknown issue. Possible values are:

- `trace`: Show every detail, like all called internal functions.
- `debug`: Shows detailed debug information.
- `info`: Normal (usually) interesting events.
- `warning`: Exceptional occurrences that are not errors.
- `error`: Runtime errors that do not require immediate action.
- `fatal`: Something went terribly wrong. App becomes unusable.

Please note that each level automatically includes log messages from a
more severe level, e.g., `debug` also shows `info` messages. By default,
the `log_level` is set to `info`, which is the recommended setting unless
you are troubleshooting.

### Option: `ssl`

Enables/Disables SSL (HTTPS). Set it `true` to enable it, `false` otherwise.

**Note**: _The SSL settings only apply to direct access and has no effect
on the Ingress service._

### Option: `certfile`

The certificate file to use for SSL.

**Note**: _The file MUST be stored in `/ssl/`, which is the default_

### Option: `keyfile`

The private key file to use for SSL.

**Note**: _The file MUST be stored in `/ssl/`, which is the default_

### Option: `request_size_limit`

By default the API calls are limited to 10MB. This should be sufficient for
most cases, however if you want to support large imports, this might be
limiting you. On the other hand you might want to limit the request size to
something smaller than that to prevent API abuse and possible DOS attack,
especially if running with limited resources.

To set the limit, you can use this setting: 10MB would be `10485760`.

### Option: `domain`

The public URL on which this Vaultwarden instance is reachable, e.g.,
`https://vaultwarden.example.com`. This sets the `DOMAIN` setting of
Vaultwarden and is **required when SSO is enabled**, since Vaultwarden
uses it to build the OpenID Connect redirect URL
(`<domain>/identity/connect/oidc-signin`).

### Option: `sso_enabled`

Enables/Disables single sign-on via OpenID Connect. Works with any
OIDC-capable identity provider (Authentik, Keycloak, Authelia, Zitadel,
Google, etc.). Set it `true` to enable it, `false` otherwise.

When enabled, the `domain`, `sso_authority`, `sso_client_id`, and
`sso_client_secret` options are required.

**Note**: _SSO in Vaultwarden handles authentication only. The account
master password is still used to encrypt/decrypt your vault._

### Option: `sso_authority`

The OpenID Connect issuer URL of your identity provider. Vaultwarden
appends `/.well-known/openid-configuration` to this URL for discovery.

For Authentik, this looks like:
`https://authentik.example.com/application/o/<application_slug>/`

### Option: `sso_client_id`

The OAuth2/OpenID Connect client ID, as configured in your identity
provider.

### Option: `sso_client_secret`

The OAuth2/OpenID Connect client secret, as configured in your identity
provider.

### Option: `sso_scopes`

The scopes requested from the identity provider. Vaultwarden defaults to
`email profile`. For Authentik, use `email profile offline_access` so
refresh tokens are issued.

### Option: `sso_allow_unknown_email_verification`

Allow logins from identity providers that do not send the
`email_verified` claim. Only enable this if you trust your provider to
verify email addresses. Defaults to `false`.

### Option: `sso_client_cache_expiration`

Number of seconds to cache the identity provider discovery metadata.
`0` disables caching (the default).

### Option: `sso_only`

Set to `true` to disable email and master password login and require SSO
for all users. **Make sure SSO login works before enabling this**, or you
may lock yourself out (the `/admin` panel remains reachable via the admin
token). Defaults to `false`.

### Option: `sso_signups_match_email`

On a user's first SSO login, link the SSO identity to an existing
Vaultwarden account with the same email address instead of creating a
new account. Defaults to `true`.

### Option: `env_vars`

Allows the setting of any additional environment variable for
Vaultwarden. This can be used to configure any Vaultwarden setting that
does not have a dedicated option in this app, including all other SSO
settings (e.g., `SSO_PKCE`, `SSO_ROLES_ENABLED`,
`SSO_ORGANIZATIONS_ENABLED`, `SSO_AUTH_ONLY_NOT_SESSION`,
`SSO_MASTER_PASSWORD_POLICY`, `SSO_DEBUG_TOKENS`).

See the [Vaultwarden configuration documentation][vaultwarden-config] and
the [Vaultwarden SSO documentation][vaultwarden-sso] for all available
settings.

Example:

```yaml
env_vars:
  - name: SSO_PKCE
    value: "true"
  - name: SIGNUPS_ALLOWED
    value: "false"
```

**Note**: _These environment variables are applied last and therefore
override any of the other options above. Settings changed in the
Vaultwarden `/admin` panel are stored in `/data/config.json` and take
precedence over environment variables._

## Known issues and limitations

- This app cannot support Ingress at this time due to technical limitations
  of the Bitwarden Vault web interface.
- Some web browsers, like Chrome, disallow the use of Web Crypto APIs in
  insecure contexts. In this case, you might get an error like
  `Cannot read property 'importKey'`. To solve this problem, you need to enable
  SSL and access the web interface using HTTPS.

## Changelog & Releases

This repository keeps a change log using [GitHub's releases][releases]
functionality.

Releases are based on [Semantic Versioning][semver], and use the format
of `MAJOR.MINOR.PATCH`. In a nutshell, the version will be incremented
based on the following:

- `MAJOR`: Incompatible or major changes.
- `MINOR`: Backwards-compatible new features and enhancements.
- `PATCH`: Backwards-compatible bugfixes and package updates.

## Support

Got questions?

You have several options to get them answered:

- The [Home Assistant Community Apps Discord chat server][discord] for app
  support and feature requests.
- The [Home Assistant Discord chat server][discord-ha] for general Home
  Assistant discussions and questions.
- The Home Assistant [Community Forum][forum].
- Join the [Reddit subreddit][reddit] in [/r/homeassistant][reddit]

You could also [open an issue here][issue] GitHub.

## Authors & contributors

The original setup of this repository is by [Franck Nijhof][frenck].

For a full list of all authors and contributors,
check [the contributor's page][contributors].

## License

MIT License

Copyright (c) 2019-2026 Franck Nijhof

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

[addon-badge]: https://my.home-assistant.io/badges/supervisor_addon.svg
[addon]: https://my.home-assistant.io/redirect/supervisor_addon/?addon=a0d7b954_bitwarden&repository_url=https%3A%2F%2Fgithub.com%2Fhassio-addons%2Frepository
[contributors]: https://github.com/hassio-addons/app-vaultwarden/graphs/contributors
[discord-ha]: https://discord.gg/c5DvZ4e
[discord]: https://discord.me/hassioaddons
[forum]: https://community.home-assistant.io/t/home-assistant-community-add-on-bitwarden-rs/115573?u=frenck
[frenck]: https://github.com/frenck
[issue]: https://github.com/hassio-addons/app-vaultwarden/issues
[reddit]: https://reddit.com/r/homeassistant
[releases]: https://github.com/hassio-addons/app-vaultwarden/releases
[semver]: https://semver.org/spec/v2.0.0.html
[vaultwarden]: https://github.com/dani-garcia/vaultwarden
[vaultwarden-config]: https://github.com/dani-garcia/vaultwarden/wiki/Configuration-overview
[vaultwarden-sso]: https://github.com/dani-garcia/vaultwarden/wiki/Enabling-SSO-support-using-OpenId-Connect
