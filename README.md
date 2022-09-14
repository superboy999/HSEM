# HSEM

Hardware semaphore for dual core communication, the whole architecture is designed by Ti's databook.

# Difference between design and Ti's databook

## Error Register

1. In SEMERR, SEMNUM has changed its width from [8-3] to [7-3].
2. FaultID has changed its width from [15-9] to [15-8].
3. 改变 semaphore 的工作模式：（1）尝试获取：先读后写 0x0 （2）尝试释放：先读后写 0x1

## Semaphore

1. write 0x0 means lock, write 0x1 means release.
2. Delete the query mechanism, move this function to software.

# Something left to do and something has been done

1. Modify semaphore acquire logic, 实际上在本次实现中并不知道怎么实现原子操作，因为不知道怎么仅读加置位还能把硬件的 id 写入 semaphore 的 owner 中。**在这种情况下，继续补充了 error 的后两种情况，但是删除了 error 的最后一种 query 机制，打算用软件来实现等待。**
2. Error reg and interrupt reg has to be writeable **实际上感觉 error 这个寄存器不需要有写操作，代码里强行加了 error 这个寄存器，实际上只读的寄存器可以仅用 wire 类型实现的，这里强行例化了 reg，为了在 ine 模块里分割出来这个 error 的功能。** _虽然实际上功能都是基本上在 regfile 里实现的_
3. 最后两个 error 的情况没办法用硬件实现，需要软件协同实现。
4. 9.14 想到一个问题，就是需要一个 interrupt stat 的寄存器，里面就两个状态：软件中断或者 error 产生的中断；另外就是需要两个中断信号，一个给 core0,一个给 core1.
