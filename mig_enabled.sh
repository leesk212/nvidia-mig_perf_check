#!/bin/bash

CUDA_VISIBLE_DEVICES=MIG-e23951c0-c8d4-5a3c-98c3-735a8168606d ./MIG_test_process_int $1 &
CUDA_VISIBLE_DEVICES=MIG-c6ff018d-5218-5f54-b0f3-2ec710713c3a ./MIG_test_process_int $1 &
CUDA_VISIBLE_DEVICES=MIG-42e5035f-2ef3-54dc-8c0d-06b4dd58d1d9 ./MIG_test_process_int $1 &
CUDA_VISIBLE_DEVICES=MIG-397166ce-e1c3-5e9f-9173-2115ff02d834 ./MIG_test_process_int $1 &

wait
