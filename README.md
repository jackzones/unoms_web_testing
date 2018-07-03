
# README

## run with tags

`cucumber --tags @test --format html -out reports.html`

## headless

设置环境变量，`echo 'export HEADLESS=true' | sudo tee -a ~/.bashrc; source ~/.bashrc`

`ENV['HEADLESS'] == 'true' ? headless : chrome`

## feature/step 书写原则

. feature 菜单之间的切换要明确写出来。如 `And 切换到用户界面`
.

## feature书写习惯

. 切换到A界面。代表A菜单的上级已经展开，不需要点击上级菜单，直接点击A菜单，若A有刷新按钮，则再点击刷新按钮。
. 进入到A界面。代表A菜单的上级未展开，需要点击上级菜单，然后再点击A菜单，不需要点击刷新按钮。
