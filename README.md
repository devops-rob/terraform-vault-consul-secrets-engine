# Consul example

## Overview

This module enables and configures the Consul secrets engine.

## Example use case

There are instances where an application may need to read or update consul components, for example, key/value data in the KV store, in an ACL enabled consul cluster. In these scenarios, developers will need to provide the application with a consul acl token.

In order to reduce the attack surface of the application, developers can leverage Vault to dynamically provision Consul ACL tokens  when an application requires access, and clean the token up when its TTL expires.

This module can be used to enable and configure the Consul secrets engine for developers to leverage as discussed above.

## Consul Requirements

Vault will require a Consul ACL token to authenticate with Consul.  To enable the ACL system in Consul, ensure the ACL stanza is declared in the Consul configuration.

The below is an example of the ACL stanza:

```json
"acl": {
      "enabled": true,
      "default_policy": "deny",
      "enable_token_persistence": true
}
```

It's best practice to create a token specifically for Vault to use. The token will need write permissions on the ACL capability.  The following policy will be sufficient for Vault to work with Consul:

```hcl
acl = "write"
```

This policy gives Vault the permissions to create, update and delete Consul ACL tokens.  It will not allow any actions outside of managing the Consul ACL system.

## Usage

```hcl
provider "vault" {
  address = "http://localhost:8200"
  token   = var.vault_token
}

variable "vault_token" {}
variable "consul_token" {}

module "consul_defaults" {
  source          = "../../"

  consul_address           = "http://localhost:8500"
  consul_token             = var.consul_token
  consul_backend_role_name = "test"

  consul_policies = [
    "test-policy",
    "test-policy-2"
  ]
}
```