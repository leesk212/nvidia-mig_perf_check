#!/bin/bash

CUDA_VISIBLE_DEVICES=MIG-d5903ff9-aecb-5f78-9295-72db4f5f623b ./MIG_test_process_int $1 &
CUDA_VISIBLE_DEVICES=MIG-d850f6ea-b7ee-572a-872c-ed8f7e0bd428 ./MIG_test_process_int $1 &
CUDA_VISIBLE_DEVICES=MIG-f17fc2b0-d31f-587b-93a2-544c75290c0d ./MIG_test_process_int $1 &
CUDA_VISIBLE_DEVICES=MIG-aeb5cf84-6113-5fee-8c6d-47040c12aca4 ./MIG_test_process_int $1 &

wait
