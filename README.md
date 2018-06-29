
# README

## run with tags

`cucumber --tags @test --format html -out reports.html`

## headless

设置环境变量，`echo 'export HEADLESS=true' | sudo tee -a ~/.bashrc; source ~/.bashrc`

`ENV['HEADLESS'] == 'true' ? headless : chrome`

## feature/step 书写原则

. feature 菜单之间的切换要明确写出来。如 `And 点击系统下的用户菜单`
. 
