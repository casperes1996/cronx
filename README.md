# cronx

cronx allows you to run commands from your crontab immediately, both specific line numbers as well as any command in the crontab.
It can also read out lines from the file, or the whole file with line numbers.
</br>
It's a simple program written in Swift. It is tested that it can be compiled and run on macOS as well as Ubuntu 20.04
</br>
Binary versions can be added by request but compiling it from source should be straightforward. Let me know if you want binary versions though.
</br>
Oh and don't judge the source code too hard ;). It was knocked out in one night since a friend could use a tool like this and it seemed like something good to make. Wasn't super worried about following all best practices.
</br>
EDIT: 
<a href="https://www.theparallelthread.com/code/cronxLinux.zip">Linux Binary</a>
</br>
Note that swift has a bug that prevents statically linking the libraries. Thus I've made a little install script that places the lib folder in the place the cronx binary expects. I only use Foundation in cronx, but the lib folder here is the entire lib folder from the swift project just cause that was easier to package up. You can clean it out yourself if you want, most of it is unnecessary for just cronx. And if you compile it yourself you can have it link to the same Foundation library all your other Swift code links to, to save space. But it's there for convenience if you don't mind wasting some megs :)
