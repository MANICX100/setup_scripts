cd what-todo/what-todo

echo "WhatTodo-server by Danny Kendall"

function master {
Start-Process pwsh -ArgumentList "-noexit", "-noprofile", "-command &{cd 'master\whatTodoAPI\bin\Debug\net7.0\';./whatTodoAPI.exe}"
Start-Process pwsh -ArgumentList "-noexit", "-noprofile", "-command &{cd 'master\whatTodoUI\';pnpm run dev}"
}

function non-relational {
Start-Process pwsh -ArgumentList "-noexit", "-noprofile", "-command &{cd 'non-relational\whatTodoUI\';pnpm run dev}"
}

$input = Read-Host "Which version of whatTodo do you want to run? master default"

if ($input -eq "non-relational") {
    non-relational
} else {
    master
}
