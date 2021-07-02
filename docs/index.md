---
layout: default
title: "Snapshot space-time holographic three-dimensional particletracking velocimetry"
---


<h2 class="section-title"> Snapshot space-time holographic 3D particle tracking velocimetry  </h2>
<h5 class="pubname"> Laser & Photonics Reviews, 2021 </h5>
<nav class="text-center" style="width: 100%">
  <a href="https://ni-chen.github.io/" class="author">Ni Chen<sup>&dagger;</sup></a>
  <a href="http://congliwang.github.io/" class="author">Congli Wang<sup>&dagger;</sup></a>
  <a href="http://vccimaging.org/People/heidriw/" class="author"> Wolfgang Heidrich </a>
</nav>
<nav>
 KAUST 
</nav>


<section class="container">
<abstract>
<h5 class="section-title">  Abstract  </h5>
Digital inline holography is an amazingly simple and effective approach for three-dimensional imaging, to which particle tracking velocimetry is of particular interest. Conventional digital holographic particle tracking velocimetry techniques are computationally separated in particle and flow reconstruction, plus the expensive computations. Usually, the particle volumes are recovered firstly, from which fluid flows are computed. Without iterative reconstructions, This sequential space-time process lacks accuracy. This paper presents a joint optimization framework for digital holographic particle tracking velocimetry: particle volumes and fluid flows are reconstructed jointly in a higher space-time dimension, enabling faster convergence and better reconstruction quality of both fluid flow and particle volumes within a few minutes on modern GPUs. Synthetic and experimental results are presented to show the efficiency of the proposed technique.
<br><br>
</abstract>
</section>


<!-- Framework -->
<section class="container">
<h5 class="section-title"> Framework </h5>
<figure>
<img src="img/teaser.svg" alt="framework" style="width: 90%">
<figcaption>
Fig. 1: Overall pipeline of our DIH-PTV space-time particle-flow reconstruction algorithm. Given single-shot hologram images, we obtained simultaneously spatial particle volumes and temporal fluid flows by solving the challenging inverse problem via alternating optimization of custom solvers with domain-specific priors.
</figcaption>
</figure>
</section>


<!-- Results -->
<section class="container">
<h5 class="section-title"> Some results  </h5>
<figure>
  <img src="img/exp_vortex_holo1.png" alt="framework" style="height: 200px">
  <img src="img/exp_vortex_holo2.png" alt="framework" style="height: 200px">
  <img src="img/Visualization%202.gif" alt="framework" style="height: 200px">
  <br>
  <img src="img/exp_inject_holo1.png" alt="framework" style="height: 200px">
  <img src="img/exp_inject_holo2.png" alt="framework" style="height: 200px">
  <img src="img/Visualization%201.gif" alt="framework" style="height: 200px">
  <figcaption>
  Fig. 2: Sample holograms and the corresponding reconstructions. 
  </figcaption>
</figure>
</section>


<!-- Data -->

<!-- Downloads -->
<section class="container">
<h5 class="section-title">  Downloads </h5>
<div class="row" style="padding-left: 36px">
The manuscript link <a href="https://onlinelibrary.wiley.com/doi/full/10.1002/lpor.202100008"> <img src="img/pdf_64x64.png" alt="pdf manuscript" class="smallimg"></a> | Github project link <a href="https://github.com/Ni-Chen/HoloFlow-PTV"><img src="img/github_64x64.png" alt="dataset" class="smallimg">
</a>
</div>
</section> 



<section class="container">
<h5 class="section-title"> Bibtex </h5>
<pre>
  @article{Chen2021LPOR,
    title      = {Snapshot space-time holographic 3D particle tracking velocimetry},
    author     = {Ni Chen and Congli Wang and Wolfgang Heidrich},
    journal    = {Laser \& Photonics Reviews},
    year       = {2021},
    month      = {April},
    doi        = {10.1002/lpor.202100008},
    url        = {https://onlinelibrary.wiley.com/doi/full/10.1002/lpor.202100008},
    }
</pre>
</section>

