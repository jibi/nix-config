{ config, ... }:

{
  _module.args.shared = {
    sshPubKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDCNtyf3z93491mDKzb+0P+Yb942u99YS168AorgXxY2YgiRwLRmXDSJybTzq8BAcfxt2grokom7PVry9BK47OIhOFgxEn+C3TJ8By0o/IFn8j8SwYGV6x1I4ut1fKuXpgz3Z4FJmx8P1EaVy0Ii6P+qtxfM7Xlxgn9I9lPBoLkDSTlW4iZLVjQrMAKEF5PI/9jvoDpdwPBIxJ1V3OwgCn6qBNdH/Lt1pytvDLb3m14Pax5MRI78F8HhnoycDWTiQ4qXQCHktsL84NMWS2YDJqi/1w0ItV7YVqF7RY1q+M7N4NqzN1ZDWHh/5FlEuh/wnzmLsgZhj6ppCgnxHtK6KYh cardno:20_892_380";

    wg = rec {
      port = 51820;

      linkPrefix = 29;
      linkSubnet = "10.200.201.0/${toString linkPrefix}";

      serverIp = "10.200.201.1";
      serverPublicKey = "fs889daXuca+k0zykPuqbN7biUxwoullJ7W8xj6ke0Q=";

      clients = {
        xps = {
          ip = "10.200.201.2";
          publicKey = "rxaNXziyh+B+KxQrrhG404Mcqhkxhs1C/Is23WRKpA4=";
        };
        iphone = {
          ip = "10.200.201.3";
          publicKey = "68tP60U0EfwlsypIEduFioz77Izhu7I5mn1iSqbb6i4=";
        };
      };

      endpoint = "${config.myconfig.hosts.home}:${toString port}";
    };
  };
}
