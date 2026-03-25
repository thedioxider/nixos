lib: pkg:
(builtins.elem (lib.getName pkg) [
  "nvidia-settings"
  "nvidia-x11"
  "cuda-merged"
  "libnvjitlink"
  "libnpp"
  "cudnn"
  "zerotierone"
  "steam"
  "steam-unwrapped"
])
|| (builtins.match "^(cuda_[a-z_]+)|(libcu[a-z]+)$" (lib.getName pkg)) != null
