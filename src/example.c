// example.c
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Your Name");
MODULE_DESCRIPTION("A simple example Linux kernel module");
MODULE_VERSION("0.1");

static int __init example_init(void) {
  printk(KERN_INFO "Example module loaded\n");
  return 0;
}

static void __exit example_exit(void) {
  printk(KERN_INFO "Example module unloaded\n");
}

module_init(example_init);
module_exit(example_exit);
