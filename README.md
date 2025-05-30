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

And after restore ssh keys, should replace remote to use git, so that this machine
can push into github

```bash
git remote remove origin
git remote add origin git@github.com:KoaLaYT/dev-env.git
```
