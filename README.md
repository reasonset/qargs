# qargs

Execute commands with singleton queue.

# Install

Copy `*.rb` to your directory on path.

# Usage

## Enqueue

```
qargs-q.rb [-lza] <queue-name> [<item>...]

  -l
        Read from STDIN and split newline instead of whitespace.

  -z
        Read from STDIN and split null character instead of whitespace.

  -a
        Use Arguments.
```

When witeout options, Read queue items from STDIN and split by whitespace.

example;

```
print -l */* | qargs-q.rb -l queueA
```

## Dequeue and execute

```
qargs.rb <queue-name> <command> [<command-arg>...]
```

example:

```
qargs.rb queueA myscript.zsh -a -b --
```

more example:

```
tmux new-session 'qargs.rb queueA myscript.zsh' \; split-window 'qargs.rb queueA myscript.zsh' \; detach-client
```
