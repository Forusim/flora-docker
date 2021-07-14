<img src="https://floracoin.farm/wp-content/uploads/2021/07/flora-xfl-logo.png.png" width="100">

# Flora Docker Container
https://floracoin.farm/

## Configuration
Required configuration:
* Publish network port via `-p 18644:18644`
* Bind mounting a host plot dir in the container to `/plots`  (e.g. `-v /path/to/hdd/storage/:/plots`)
* Bind mounting a host config dir in the container to `/root/.flora`  (e.g. `-v /path/to/storage/:/root/.flora`)
* Set initial `flora keys add` method:
  * Manual input from docker shell via `-e KEYS=type` (recommended)
  * Copy from existing farmer via `-e KEYS=copy` and `-e CA=/path/to/mainnet/config/ssl/ca/` 
  * Add key from mnemonic text file via `-e KEYS=/path/to/mnemonic.txt`
  * Generate new keys (default)

Optional configuration:
* Pass multiple plot directories via PATH-style colon-separated directories (.e.g. `-e plots_dir=/plots/01:/plots/02:/plots/03`)
* Set desired time zone via environment (e.g. `-e TZ=Europe/Berlin`)

On first start with recommended `-e KEYS=type`:
* Open docker shell `docker exec -it <containerid> sh`
* Enter `flora keys add`
* Paste space-separated mnemonic words
* Enter `flora wallet show`
* Press `S` to skip restore from backup
* Restart docker cotainer

## Operation
* Open docker shell `docker exec -it <containerid> sh`
* Check synchronization `flora show -s -c`
* Check farming `flora farm summary`
* Check balance `flora wallet show summary` 
