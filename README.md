
# README

## run with tags

`cucumber --tags @test --format html -out reports.html`

## headless

设置环境变量，`echo 'export HEADLESS=true' | sudo tee -a ~/.bashrc; source ~/.bashrc`

`ENV['HEADLESS'] == 'true' ? headless : chrome`
