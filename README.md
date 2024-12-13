# save & restore ssh keys

This is not a regular tasks, so just do it manually

```bash
# save
tar czf ssh.tar.gz --directory ~/.ssh .
gpg --symmetric ssh.tar.gz
mv ssh.tar.gz.gpg encrypts
rm -rf ssh.tar.gz

# restore
gpg --decrypt encrypts/ssh.tar.gz.gpg > /tmp/ssh.tar.gz
tar xf /tmp/ssh.tar.gz --directory=~/.ssh
```
