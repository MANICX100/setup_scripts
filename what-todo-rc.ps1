echo "WhatTodo-server by Danny Kendall"

function master {
Start-Process pwsh -ArgumentList "-noexit", "-noprofile", "-command &{cd 'master\whatTodoAPI\bin\Debug\net7.0\';./whatTodoAPI.exe}"
Start-Process pwsh -ArgumentList "-noexit", "-noprofile", "-command &{cd 'master\whatTodoUI\';pnpm run dev}"
}

function non-relational {
Start-Process pwsh -ArgumentList "-noexit", "-noprofile", "-command &{cd $env:USERPROFILE/whatTodoUI/whatTodoUI;pnpm run dev}"
}

non-relational
