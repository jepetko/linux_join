![CircleCI state](https://circleci.com/gh/jepetko/linux_join.png?circle-token=1af4af3ace9ad752f06f9dd86385bc2683adff3e&style=shield)

# linux_join

ruby implementation of the join command

Example:

```bash
# join /etc/group and /etc/passwd by the primary group ID
ruby join.rb -t ':' -1 3 -2 4 -o '1.1 2.1 2.7' /etc/group /etc/passwd
```
