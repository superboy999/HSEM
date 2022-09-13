# HSEM
Hardware semaphore for dual core communication, the whole architecture is designed by Ti's databook.  
# Difference between design and Ti's databook
## Error Register 
1. In SEMERR, SEMNUM has changed its width from [8-3] to [7-3].
2. FaultID has changed its width from [15-9] to [15-8].
3. 改变semaphore的工作模式：（1）尝试获取：先读后写0x0 （2）尝试释放：先读后写0x1
# Something left to do and something has been done
1. Modify semaphore acquire logic, 实际上在本次实现中并不知道怎么实现原子操作，因为不知道怎么仅读加置位还能把硬件的id写入semaphore的owner中。==在这种情况下，继续补充了error的后两种情况==
2. Error reg and interrupt reg has to be writeable
3. 最后两个error的情况没办法用硬件实现，需要软件协同实现。
4. ine模块需要进一步实现