## .zipping

For zip a folder or a file you can use the alias functions for zipping. If not done you have to import the aliases from the .zipping file to your .profile.


Here an example how to zip and unzip with encryption:

Lets say you have a folder '/home/johndoe/docs' and you want to zip and encrypt it. Change from the shell to the home folder of the user johndoe '/home/johndoe' and execute the following command:

```shell
:~$  zipAndEncrypt docs/ docs.enc
```

You will be prompted twice to enter a password for the encryption. If everything goes right the output will be the zip-file 'docs.enc'.

If you want later to decrypt the zip-file 'docs.enc' change to the folder where the zip-file is and execute the following command:

```shell
:~$  unzipAndDencrypt docs.enc
```
You will be prompted to enter the password for the decryption of the zip-file. 
If the password is correct the zip-file 'docs.enc' will be unzip in the current folder.
