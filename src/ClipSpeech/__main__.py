import sys, os
# 为了兼容-m模式运行，我们主动将当前目录加入到sys.path，这样就能搜索本项目的的模块
sys.path.append(os.path.dirname(__file__))
from app import main

if __name__ == '__main__':
    main()
